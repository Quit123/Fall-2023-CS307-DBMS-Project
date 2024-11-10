# 📺Fall-2023-CS307-DBMS-Project
## ER diagram
<img width="788" alt="image" src="https://github.com/user-attachments/assets/4e156cb8-8557-416b-9d96-2e9039f4c257">

# 1. Group Introduction and Contribution
**Zhu Jianuo**, 12210404, Tuesday 1st-2nd Period
**Wang Ziheng**, 12310401, Tuesday 1st-2nd Period
**Zhang Bojun**, 12211615, Tuesday 1st-2nd Period  
Contribution Ratio: 1:1:1

# 2. Database Design (15%)
## 2.1 ER Diagram
## 2.2 Database Visualization
## 2.3 Table Descriptions

**t_user Table**:  
Represents user information with fields including the number of coins (coins), name (name), gender (sex), birthday (birthday), level (level), zodiac sign (sign), identity (identity), password (password), QQ number (qq), WeChat number (wechat), and a foreign key (mid).

**follows Table**:  
Describes the following relationship between users, containing two fields: follower (follower) and followee (followee).

**videos Table**:  
Represents video information, containing fields like video title (title), uploader (mid), name (name), submission time (commit_time), review time (review_time), publish time (public_time), duration (duration), description (description), reviewer (reviewer), and a foreign key (bv).

**view Table**:  
Records video view counts, including view count (view) and two foreign keys (bv and mid).

**liker Table**:  
Records video like information, containing fields like liker (bv) and video ID (mid).

**coin Table**:  
Records the coin donation action, including donator (bv) and video ID (mid).

**favorite Table**:  
Records video collection actions, containing user ID (bv) and video ID (mid).

**danmu Table**:  
Represents video bullet chat information, including bullet chat ID (id), content (content), post time (posttime), and two foreign keys (mid and bv).

**danmu_like Table**:  
Records bullet chat like information, including the liked bullet chat ID (id) and the user who liked it (likeby).

### Relationships Between Tables:
- **t_user** and **follows**: Users can have multiple followers and followees through the `mid` field in the t_user table.
- **t_user** and **videos**: Users can upload multiple videos through the `mid` field.
- **videos** and **view**: A video can have multiple view records through the `bv` field.
- **videos** and multiple tables (like, coin, favorite): A video can have multiple likes, coin donations, and collections through the `bv` field.
- **danmu** and **danmu_like**: A bullet chat can be liked by multiple users through the `id` field.

The relationships are represented by connecting lines between tables, with arrows indicating the direction from foreign keys to primary keys.

This design helps efficiently manage data related to users, videos, view records, likes, coins, collections, and bullet chats, while reflecting their interrelationships.

# 3. Basic API Specification
## 3.1 Implementation Description
### **RecommenderService**
- **List<String> recommendNextVideo(String bv)**:
  This method recommends the five most similar videos based on the number of users who watched both videos. It takes a video identifier (`bv`) as a parameter. If the video is not found in the database, it returns null.
  
- **List<String> generalRecommendations(int pageSize, int pageNum)**:
  This method recommends videos based on their popularity for anonymous users. The popularity is evaluated from five aspects: like ratio, coin donation ratio, favorite ratio, average number of bullet chats, and average completion percentage of views. The recommendation score is the sum of these five values. The method uses SQL to join the videos table with the view, liker, coin, favorite, and danmu tables to calculate each video's score. It returns videos sorted by score. It accepts `pageSize` and `pageNum` as parameters. If the requested page number is invalid or the page has no videos, it returns null or an empty list.

- **List<String> recommendVideosForUser(AuthInfo auth, int pageSize, int pageNum)**:
  This method recommends videos based on the user's friends' interests. Friends are defined as those who follow the user and are also followed by the user. The method sorts recommended videos by the number of views from friends, uploader’s level, and video publication time. If the user has no friends who have watched videos, it falls back to general recommendations. The method accepts user authentication info (`auth`), `pageSize`, and `pageNum` as parameters.

- **List<Long> recommendFriends(AuthInfo auth, int pageSize, int pageNum)**:
  This method recommends potential friends based on mutual followers. It sorts users who the current user does not follow yet but shares at least one common follower. The sorting is based on the number of mutual followers and then by level. It accepts `auth`, `pageSize`, and `pageNum` as parameters.

### **UserService**
- **public long register(RegisterUserReq req)**:
  This method checks if the user registration details meet the required criteria (password, name, sex, birthday format, etc.), ensures no duplicate information, and inserts the data into the `t_user` table.

- **public boolean deleteAccount(AuthInfo auth, long mid)**:
  This method checks if the user exists and if the provided authentication (`auth`) is valid. It also verifies if the user has permission to delete the account before performing the delete operation.

- **public boolean follow(AuthInfo auth, long followeeMid)**:
  This method checks if the user (`auth`) is already following the `followeeMid`. If they are, it unfollows the user. If not, it follows the user by inserting a record into the `follows` table.

- **public UserInfoResp getUserInfo(long mid)**:
  This method returns user information using several helper functions that query the database and ensure only one SQL query is executed for each method.

### **VideoService**
- **public String postVideo(AuthInfo auth, PostVideoReq req)**:
  This method checks the `auth` and `req` and inserts video data into the `video` table after generating a random BV number.

- **public boolean deleteVideo(AuthInfo auth, String bv)**:
  This method deletes a video from the `video` table based on the `bv` identifier after checking the provided authentication and request data.

- **public boolean updateVideoInfo(AuthInfo auth, String bv, PostVideoReq req)**:
  This method updates video details in the `video` table, resetting the review time and reviewer information.

- **public List<String> searchVideo(AuthInfo auth, String keywords, int pageSize, int pageNum)**:
  This method searches for videos based on keywords, sorting by the frequency of the keywords and using a custom comparator for dual-criteria sorting.

- **public double getAverageViewRate(String bv)**:
  This method calculates the average view rate of a video by querying the view table for records and calculating the average.

- **public Set<Integer> getHotspot(String bv)**:
  This method calculates the most popular times for bullet chats by querying the database and identifying time segments with the highest number of bullet chats.

- Other methods for video review, coin donation, liking, and collecting are implemented similarly, checking authentication and updating the respective tables.

### **DanmuService**
- **checkUser(Connection conn, AuthInfo auth)**:
  This method verifies the user's existence and checks if the provided password matches the stored password in the database.

- **get_mid(Connection conn, AuthInfo auth, String sentence1, String sentence2)**:
  This method retrieves the user ID (`mid`) based on the provided authorization info and SQL query.

- **sendDanmu(AuthInfo auth, String bv, String content, float time)**:
  This method inserts a bullet chat message into the database after validating the user and message content.

- **displayDanmu(String bv, float timeStart, float timeEnd, boolean filter)**:
  This method retrieves and returns the list of bullet chat messages within a specific time range for a video.

- **likeDanmu(AuthInfo auth, long id)**:
  This method allows users to like or unlike a bullet chat message.

### **DatabaseServiceImpl**
- **ImportData**:
  This method handles the importation of data into the database using multiple threads to speed up the process. It creates a connection pool using HikariDataSource and performs data import through parallel threads.

# 4. Advanced API
## 4.1 Advanced Features
- **Logger**:  
  A custom Logger class is implemented to log different types of activities (debug, SQL, and function logs) into separate text files stored in the "logs" directory, with file names based on the date.

- **Rollback**:  
  A rollback mechanism is implemented to restore the database to its previous state in case of errors or failures.

- **Connection Pool**:  
  HikariDataSource is used for database connection pooling, improving the performance of data imports and queries by using multiple parallel connections.

- **User Password Encryption**:  
  AES encryption is used to secure user passwords stored in the database. The password is encrypted before being stored, and decrypted when verified during login.

- **Multithreading**:  
  Multithreading is used to speed up data imports and query executions, enabling parallel processing for large-scale data operations.

## 4.2 Results of the Advanced Features Experiment
- **Logger**
- **Rollback**
- **Connection Pool**
- **User Password Encryption System
