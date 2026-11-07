import 'package:user_servicehub/data/models/review_model.dart';

final List<ReviewModel> mockReviews = [
  const ReviewModel(
    id: 'REV001',
    userId: 'USR002',
    userName: 'Ravi Mehta',
    userPhotoUrl: 'assets/images/users/ravi_mehta.jpg',
    rating: 5.0,
    comment:
        'Excellent AC repair service! Priya was very professional and fixed the issue within an hour. Highly recommended!',
    date: '2026-07-28',
    serviceName: 'AC Repair & Service',
    images: ['assets/images/reviews/ac_repair_1.jpg'],
  ),
  const ReviewModel(
    id: 'REV002',
    userId: 'USR003',
    userName: 'Sunita Agarwal',
    userPhotoUrl: 'assets/images/users/sunita_agarwal.jpg',
    rating: 4.5,
    comment:
        'Good plumbing service. Vikram fixed all the leaks and even replaced old pipes. Slight delay in arrival but work was neat.',
    date: '2026-07-26',
    serviceName: 'Plumbing Services',
    images: [],
  ),
  const ReviewModel(
    id: 'REV003',
    userId: 'USR004',
    userName: 'Anjali Deshmukh',
    userPhotoUrl: 'assets/images/users/anjali_deshmukh.jpg',
    rating: 5.0,
    comment:
        'Best cleaning service I have used in Delhi. Sneha and her team did a thorough deep clean. Sparkling results!',
    date: '2026-07-24',
    serviceName: 'Home Cleaning',
    images: ['assets/images/reviews/cleaning_1.jpg', 'assets/images/reviews/cleaning_2.jpg'],
  ),
  const ReviewModel(
    id: 'REV004',
    userId: 'USR005',
    userName: 'Vivek Saxena',
    userPhotoUrl: 'assets/images/users/vivek_saxena.jpg',
    rating: 4.0,
    comment:
        'Amit is a skilled electrician. Solved our complex wiring issue. Would have given 5 stars but took a bit longer than expected.',
    date: '2026-07-22',
    serviceName: 'Electrician Services',
    images: [],
  ),
  const ReviewModel(
    id: 'REV005',
    userId: 'USR006',
    userName: 'Pooja Jain',
    userPhotoUrl: 'assets/images/users/pooja_jain.jpg',
    rating: 5.0,
    comment:
        'Beautiful painting job by Rajan ji! Our home looks brand new. Very clean work and great color advice.',
    date: '2026-07-19',
    serviceName: 'Painting Services',
    images: ['assets/images/reviews/painting_1.jpg', 'assets/images/reviews/painting_2.jpg', 'assets/images/reviews/painting_3.jpg'],
  ),
  const ReviewModel(
    id: 'REV006',
    userId: 'USR007',
    userName: 'Arvind Nair',
    userPhotoUrl: 'assets/images/users/arvind_nair.jpg',
    rating: 3.5,
    comment:
        'Carpenter work was okay. The furniture assembly was done properly but the finishing could have been better. Fair for the price.',
    date: '2026-07-16',
    serviceName: 'Carpenter Services',
    images: [],
  ),
  const ReviewModel(
    id: 'REV007',
    userId: 'USR008',
    userName: 'Kavita Mishra',
    userPhotoUrl: 'assets/images/users/kavita_mishra.jpg',
    rating: 4.5,
    comment:
        'Loved the beauty services at home! Neha did a wonderful facial and waxing. Very convenient and hygienic.',
    date: '2026-07-14',
    serviceName: 'Beauty & Parlour',
    images: ['assets/images/reviews/beauty_1.jpg'],
  ),
];
