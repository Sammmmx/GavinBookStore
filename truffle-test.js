const _GavinBookStore = artifacts.require("GavinBookStore");

contract("GavinBookStore", (accounts) => {
  const owner = accounts[0];
  const user = accounts[1];
  let store;

  before(async () => {
    store = await _GavinBookStore.new();
  });

  it("should set deployer as owner", async () => {
    const contractOwner = await store.owner();
    assert.equal(contractOwner, owner);
  });

  it("should allow owner to add a book", async () => {
    await store.addBook("The Alchemist", "Paulo Coelho", "HarperCollins", {
      from: owner,
    });
    const details = await store.getDetailsById(1);
    assert.equal(details[0], "The Alchemist");
    assert.equal(details[1], "Paulo Coelho");
    assert.equal(details[2], "HarperCollins");
    assert.equal(details[3], true);
  });

  it("should allow finding book by title", async () => {
    const result = await store.findBookByTitle("The Alchemist", { from: user });
    assert.equal(result.length, 1);
    assert.equal(result[0].toNumber(), 1);
  });

  it("should allow finding book by publication", async () => {
    const result = await store.findAllBooksOfPublication("HarperCollins", {
      from: user,
    });
    assert.equal(result.length, 1);
    assert.equal(result[0].toNumber(), 1);
  });

  it("should allow finding book by author", async () => {
    const result = await store.findAllBooksOfAuthor("Paulo Coelho", {
      from: user,
    });
    assert.equal(result.length, 1);
    assert.equal(result[0].toNumber(), 1);
  });

  it("should not allow non-owner to add a book", async () => {
    try {
      await store.addBook("1984", "George Orwell", "Secker & Warburg", {
        from: user,
      });
      assert.fail("Expected revert");
    } catch (err) {
      assert.include(err.message, "Only owner can access this function");
    }
  });

  it("should allow owner to remove book", async () => {
    await store.removeBook(1, { from: owner });
    try {
      await store.getDetailsById(1, { from: user });
      assert.fail("Expected revert");
    } catch (err) {
      assert.include(err.message, "Book not available");
    }
  });

  it("should allow owner to update book details", async () => {
    await store.addBook("Sapiens", "Yuval Noah Harari", "Penguin", {
      from: owner,
    });
    await store.updateDetails(
      2,
      "Sapiens Updated",
      "Yuval",
      "Penguin Books",
      true,
      { from: owner },
    );
    const updated = await store.getDetailsById(2);
    assert.equal(updated[0], "Sapiens Updated");
    assert.equal(updated[1], "Yuval");
    assert.equal(updated[2], "Penguin Books");
    assert.equal(updated[3], true);
  });

  it("should reject update from non-owner", async () => {
    try {
      await store.updateDetails(2, "Fake", "User", "TestPub", false, {
        from: user,
      });
      assert.fail("Expected revert");
    } catch (err) {
      assert.include(err.message, "Only owner can access this function");
    }
  });
});
