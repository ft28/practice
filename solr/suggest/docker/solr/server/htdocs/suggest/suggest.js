(function() {
    var base_url = '/solr/sample01/suggest?wt=json&suggest=true&suggest.count=5';
    var base_url1 = base_url + '&suggest.q=';
    var base_url2 = base_url + '&suggest.dictionary=default&suggest.dictionary=roman1&suggest.q=';
    var base_url3 = base_url + '&suggest.dictionary=default&suggest.dictionary=roman1&suggest.cfq=1&suggest.q=';
    var base_url4 = base_url + '&suggest.dictionary=roman2&suggest.q=';
    var pre_query = null;

    var input = document.getElementById("input");

    var result1 = document.getElementById("test1");
    var result2 = document.getElementById("test2");
    var result3 = document.getElementById("test3");
    var result4 = document.getElementById("test4");

    input.addEventListener('keyup', function(e) {
      update(input.value.trim());
    });

    input.addEventListener('keydown', function(e) {
      update(input.value.trim());
    });

    function update(value) {
      if (value == pre_query) {
        return;
      }
      pre_query = value;
      result1.innerHTML = '';
      result2.innerHTML = '';
      result3.innerHTML = '';
      result4.innerHTML = '';
       
      if (value == '') {
        return;
      }
      update_result(base_url1, value, result1);
      update_result(base_url2, value, result2);
      update_result(base_url3, value, result3);
      update_result(base_url4, value, result4);
    }

    function update_result(base_query, value, result) {
      fetch(base_query + encodeURI(value))
        .then(function(res) {
          if ((res.status !== 200) && (res.status !== 0)) {
            return Promise.reject(new Error(res.statusText));
          }
          return Promise.resolve(res);
        })
        .then(function(res) { return res.json(); })
        .then(function(data) {
          var suggests = [];
          if (data['suggest']['default']) {
            data['suggest']['default'][value]['suggestions'].forEach(function(x) {
              suggests.push(x['payload'] + " " + x['weight']);
            });
          }
          if (data['suggest']['roman1']) {
            data['suggest']['roman1'][value]['suggestions'].forEach(function(x) {
              suggests.push(x['payload'] + " " + x['weight']);
            });
          }
          if (data['suggest']['roman2']) {
            data['suggest']['roman2'][value]['suggestions'].forEach(function(x) {
              suggests.push(x['payload'] + " " + x['weight']);
            });
          }
          update_ul(result, suggests);
        })
        .catch(function(err) {
           var suggests = ['error', 'error'];
           console.log(err);
           update_ul(result, suggests);
        });
    }
    
    function update_ul(result, suggests) {
      var buf = '';
      suggests.forEach(function(x) {
        buf += '<li>' + x + '<li>';
      });
      result.innerHTML = buf;
    }
})();
