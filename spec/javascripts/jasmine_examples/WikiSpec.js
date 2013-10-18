describe("Wikipage", function() {
  var url;
  var searchText;
  var replaceText;

  beforeEach(function() {
    url = "http://en.wikipedia.org/wiki/Internet";
    searchText = "internet"; // appropriate to test here?
    replaceText = "reiman";  // this is more of a controller test
  });

  it("should be able to get a page", function() {
    MakeRequest.init();
    var response = ""
    // how to pass url to rails ajax get ??

    //demonstrates use of custom matcher
    expect(response).toContain("internet");
  });

})