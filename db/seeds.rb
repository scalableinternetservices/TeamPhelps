# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#

Comment.destroy_all
Comment.reset_pk_sequence

Post.destroy_all
Post.reset_pk_sequence

Role.destroy_all
Role.reset_pk_sequence

User.destroy_all
User.reset_pk_sequence

Course.destroy_all
Course.reset_pk_sequence

require 'set'

n_users = 100
n_courses = 50
n_posts_per_course = 20
n_comments_per_post = 20
n_posts = n_courses * n_posts_per_course


def rand_n(n, min, max)
  randoms = Set.new
  loop do
    randoms << rand(min..max)
    return randoms.to_a if randoms.size >= n
  end
end


n_users.times do |index|
  User.create!(name: "User#{index+1}",
               email: "user#{index+1}@example.com")
end

p "Created #{User.count} users"

n_courses.times do |index|
  Course.create!(name: "Course#{index+1}")
end

p "Created #{Course.count} courses"

n_courses.times do |index1|
  n_posts_per_course.times do |index2|
    Post.create!(course_id: index1+1,
                 user_id: index2+1,
                 title: "Post#{index1+1}-#{index2+1}",
                 body: "Sample body for post#{index1+1}-#{index2+1}")
  end
end

p "Created #{Post.count} posts"

n_posts.times do |index1|
  n_comments_per_post.times do |index2|
    Comment.create!(user_id: index2+1,
                    post_id: index1+1,
                    body: "Sample body for comment#{index1+1}-#{index2+1}")
  end
end

p "Created #{Comment.count} comments"

50.times do |course|

  # generate random number of instructors between 1-3 for a course
  instructors = rand_n(rand(1..4), 1, n_users)

  # generate random number of TAs between 1-6 for a course
  tas = rand_n(rand(1..7), 1, n_users)

  # remove instructors from list of TAs
  tas.delete_if {|t| instructors.include? t}

  # remove instructors and TAs from list of student
  students = rand_n(50, 1, n_users)
  students.delete_if {|s| instructors.include? s}
  students.delete_if {|s| tas.include? s}

  instructors.each do |instructor|
    Role.create!(user_id: instructor,
                 course_id: course+1,
                 role: 0)
  end

  tas.each do |ta|
    Role.create!(user_id: ta,
                 course_id: course+1,
                 role: 2)
  end

  students.each do |student|
    Role.create!(user_id: student,
                 course_id: course+1,
                 role: 1)
  end

end

p "Created #{Role.count} roles"
