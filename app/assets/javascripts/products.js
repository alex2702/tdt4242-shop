/*
 * This code manages the query string in the URL and the values of the filter and search elements, ensuring consistency
 * between them
 */

function createList(paramString, paramName) {
    var pos = paramString.search(paramName);
    if (pos != -1) {
        var tempParamString = paramString.substring(pos + paramName.length);
        var endpos = tempParamString.indexOf("&");
        if (endpos != -1) {
            tempParamString = tempParamString.substring(0, endpos);
        }
        var list = tempParamString.split("_");
        return list.slice(0, list.length - 1);
    } else {
        return null;
    }
}

function getPrice(paramString, paramName) {
    var pos = paramString.search(paramName);
    if (pos != -1) {
        var tempParamString = paramString.substring(pos + paramName.length);
        var endpos = tempParamString.indexOf("&");
        if (endpos != -1) {
            tempParamString = tempParamString.substring(0, endpos);
        }
        return tempParamString
    } else {
        return null;
    }
}

function searchString(paramString) {
    var pos = paramString.search("search=");
    if (pos != -1) {
        return paramString.substring(pos + 7);
    } else {
        return null;
    }
}

/*
 * This function creates a list of the parameters in the query string in the URL, the two first elements also being
 * lists, functions above are helper functions for this
 */

function listFromParams() {
    var brand, material, lprice, hprice;
    var paramString = window.location.href;
    var pos = paramString.indexOf("?");

    if (pos != -1) {
        paramString = paramString.substring(pos + 1);
        brand = createList(paramString, "brand=");
        material = createList(paramString, "material=");
        lprice = getPrice(paramString, "lprice=");
        hprice = getPrice(paramString, "hprice=");
        search = searchString(paramString);
        return [brand, material, lprice, hprice, search];
    } else {
        return [null, null, null, null, null];
    }
}


/*
 * This function builds the query string for the URL from the listed created by listFromParams()
 */

function buildQueryUrl(list) {
    var queryString = "?";
    if (list[0] !== null && list[0].length != 0) {
        queryString += "brand=";
        for (i = 0; i < list[0].length; i++) {
            queryString += list[0][i] + "_";
        }
    }
    if (list[1] !== null && list[1].length != 0) {
        if (queryString != "?") {
            queryString += "&";
        }
        queryString += "material=";
        for (i = 0; i < list[1].length; i++) {
            queryString += list[1][i] + "_";
        }
    }
    if (list[2] !== null && list[2] !== "") {
        if (queryString != "?") {
            queryString += "&";
        }
        queryString += "lprice=" + list[2];
    }
    if (list[3] !== null && list[3] !== "") {
        if (queryString != "?") {
            queryString += "&";
        }
        queryString += "hprice=" + list[3];
    }
    if (list[4] !== null && list[4] !== "") {
        if (queryString != "?") {
            queryString += "&";
        }
        queryString += "search=" + list[4];
    }
    if (queryString == "?") {
        queryString = "";
    }
    return queryString;
}

function checkboxClick(checkbox, type) {
    var list = listFromParams();
    if (checkbox.checked) {
        if (type == "brand") {
            if (list[0] === null) {
                list[0] = [checkbox.id];
            } else {
                if (list[0].indexOf(checkbox.id) == -1) {
                    list[0].push(checkbox.id);
                }
            }
        }
        if (type == "material") {
            if (list[1] === null) {
                list[1] = [checkbox.id];
            } else {
                if (list[1].indexOf(checkbox.id) == -1) {
                    list[1].push(checkbox.id);
                }
            }
        }
        window.location.search = buildQueryUrl(list);
    } else {
        if (type == "brand") {
            if (list[0] !== null) {
                var pos = list[0].indexOf(checkbox.id);
                if (pos != -1) {
                    list[0].splice(pos, 1);
                }
            }
        }
        if (type == "material") {
            if (list[1] !== null) {
                var pos = list[1].indexOf(checkbox.id);
                if (pos != -1) {
                    list[1].splice(pos, 1);
                }
            }
        }
        window.location.search = buildQueryUrl(list);
    }
}

function priceInput(price, type) {
    var list = listFromParams();
    if (type == "lprice") {
        list[2] = price.value;
    }
    if (type == "hprice") {
        list[3] = price.value;
    }
    window.location.search = buildQueryUrl(list);
}

function searchInput(searchBar) {
    var list = listFromParams();
    list[4] = searchBar.value;
    window.location.search = buildQueryUrl(list);
}

/* This runs on page load, updates filter/search value to those in the query url */
$(document).ready(function() {
    var queryParams = listFromParams();
    for (i = 0; i < 2; i++) {
        if (queryParams[i] != null) {
            for (j = 0; j < queryParams[i].length; j++) {
                document.getElementById(queryParams[i][j]).checked = true;
            }
        }
    }

    queryParams[2] != null ? document.getElementById("lprice").value = queryParams[2] : '';
    queryParams[3] != null ? document.getElementById("hprice").value = queryParams[3] : '';
    queryParams[4] != null ? document.getElementById("search").value = queryParams[4] : '';

    /* custom error message for amount selection of products */
    inputs = document.getElementsByClassName('amount-input');
    for(var i = 0; i < inputs.length; i++) {
        (function(index) {
            inputs[index].addEventListener('invalid', function(e) {
                if(inputs[index].validity.rangeOverflow) {
                    e.target.setCustomValidity('We only have ' + inputs[index].max + ' items of this product in stock.');
                }
            }, false);
            inputs[index].addEventListener('input', function(e){
                e.target.setCustomValidity('');
            });
        })(i);
    }



});