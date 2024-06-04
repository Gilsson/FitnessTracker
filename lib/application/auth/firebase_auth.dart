import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitness_sync/application/user/user_service.dart';
import 'package:fitness_sync/domain/abstractions/unit_of_work.dart';
import 'package:fitness_sync/domain/entities/data/statistics.dart';
import 'package:fitness_sync/domain/entities/user/user_domain.dart';
import 'package:fitness_sync/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthentication {
  FirebaseApp? firebaseApp;
  final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UnitOfWork unitOfWork;
  FirebaseAuthentication({required this.unitOfWork});

  Future<void> completeUserProfile({
    required String gender,
    required String dateOfBirth,
    required String weight,
    required String height,
  }) async {
    try {
      initializeFirebase();
      User? user = _auth.currentUser;
      if (user != null) {
        UserDomain? user_domain = await unitOfWork.userRepository
            .getFirst([(o) => o.mail == user.email!]);

        if (user_domain != null) {
          if (DateTime.tryParse(dateOfBirth) == null) {
            throw Exception('Invalid date of birth!');
          }
          if (!(gender == "Male" || gender == "Female")) {
            throw Exception('Invalid gender!');
          }

          if (weight == "") {
            throw Exception('Invalid weight!');
          }
          if (height == "") {
            throw Exception('Invalid height!');
          }
          var stat = await unitOfWork.statisticsRepository.add(
              Statistics.withId(
                  type: StatisticsType.age,
                  value:
                      (DateTime.now().year - DateTime.parse(dateOfBirth).year)
                          .toDouble(),
                  userId: user_domain.id));

          user_domain.statistics.add(stat);
          stat = await unitOfWork.statisticsRepository.add(Statistics.withId(
              type: StatisticsType.weight,
              value: double.parse(weight),
              userId: user_domain.id));
          user_domain.statistics.add(stat);
          stat = await unitOfWork.statisticsRepository.add(Statistics.withId(
              type: StatisticsType.sex,
              value: gender == "Male" ? 0.0 : 1.0,
              userId: user_domain.id));
          user_domain.statistics.add(stat);
          stat = await unitOfWork.statisticsRepository.add(Statistics.withId(
              type: StatisticsType.height,
              value: double.parse(height) / 100.0,
              userId: user_domain.id));
          user_domain.statistics.add(stat);

          await unitOfWork.userRepository.update(user_domain);
        } else {
          throw Exception('No user domain');
        }
      } else {
        throw Exception('No user is signed in');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> initializeFirebase() async {
    if (firebaseApp != null) {
      return;
    }
    firebaseApp = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    return;
  }

  Future<UserDomain> signUp(
      {required String mail,
      required String password,
      required String name,
      required String lastName}) async {
    try {
      var newUser = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: mail, password: password);
      UserDomain user = UserDomain(
        mail: mail,
        hashPassword: password, // Store hashed password instead
      );

      user.name = name + " " + lastName;
      user.heartRateData = [];
      user.stepData = [];
      user.sleepData = [];
      user.achievements = [];
      user.userData = [];
      user.statistics = [];
      return UserService(unitOfWork).add(user);
    } on FirebaseAuthException catch (e) {
      rethrow; // Re-throw FirebaseAuthException to be caught in the calling method
    } catch (e) {
      rethrow; // Re-throw any other exceptions to be caught in the calling method
    }
  }

  Future<UserCredential?> signIn(
      {required String mail, required String password}) async {
    return FirebaseAuth.instance
        .signInWithEmailAndPassword(email: mail, password: password);
  }
}
