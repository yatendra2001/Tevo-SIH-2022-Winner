String generateChannelId(String senderUsername, String receiverUsername) {
  List<String> ids = [senderUsername, receiverUsername];
  ids.sort();
  return ids.join();
}
