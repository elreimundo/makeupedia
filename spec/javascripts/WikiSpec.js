describe("Wikipage", function() {

  beforeEach(function() {
    $clone = $(document).clone( true )
  });

  afterEach(function () {
    //var newDoc = document.open("text/html", "replace");
    //newDoc.write($clone);
    //newDoc.close();
  });

  it("should append changed text to a page", function() {
    var data = {};
    data.content = "<p>stuff</p>";
    //MakeRequest.appendResponse("event", data);

    expect(document).toContain("stuff");
  });

})