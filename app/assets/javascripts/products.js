/*
 * This code manages the query string in the URL and the values of the filter and search elements, ensuring consistency
 * between them
 */

const PARAMS = ["brand", "material", "lprice", "hprice", "search"]

/* 
 * Attempts to get the parameter value from a given parameter string and the parameter name
 * returns null if the parameter name is not found in the parameter string
 */
function getParam(paramString, paramName) {
    let pos = paramString.search(paramName + "=");
    if (pos !== -1){
        let tempParamString = paramString.substring(pos + paramName.length + 1);
        let endpos = tempParamString.indexOf("&");
        if (endpos !== -1) {
            tempParamString = tempParamString.substring(0, endpos);
        }
        return tempParamString;
    } else {
        return null;
    }
}
/*
 * Removes all empty strings from an array
 */
function removeEmptyStringsFromArray(array) {
    let pos = array.indexOf("");
    while (pos !== -1) {
        array.splice(pos, 1);
        pos = array.indexOf("");
    }
}

/*
 * Creates a dictionary containing the values of the parameters in the URL
 */
function dictFromParams() {
    let dict = {};
    let paramString = window.location.href;
    let pos = paramString.indexOf("?");
    
    PARAMS.forEach(function(paramName) {
        let paramValue = getParam(paramString, paramName);
        if (paramValue !== null) {
            let array = getParam(paramString, paramName).split('_');
            removeEmptyStringsFromArray(array);
            if (array.length !== 0) {
                dict[paramName] = array;
            } else {
                dict[paramName] = null;
            }
        } else {
            dict[paramName] = null;
        }
    });
    return dict;
}

/*
 * Builds the query part of the URL and changes the URL to that, causing a GET request with the new URL
 */
function buildQueryUrl(dict) {
    let queryString = "?";
    PARAMS.forEach(function(paramName) {
        if (dict[paramName] !== null) {
            if (queryString !== "?") {
                queryString += "&";
            }
            queryString += paramName + "=";
            dict[paramName].forEach(function(paramValue) {
                if (queryString[queryString.length - 1] !== "=") {
                    queryString += "_";
                }
                queryString += paramValue;
            });
        }
    });
    return queryString;
}

/*
 * On a checkbox click, creates a parameter value dictionary and updates it with the changed checkbox value before changing in the URL,
 * causing a GET request to be sent with the new URL
 */
function checkboxClick(checkbox, type) {
    let dict = dictFromParams();
    if (checkbox.checked) {
        if (dict[type] === null) {
            dict[type] = [checkbox.id];
        } else {
            if (dict[type].indexOf(checkbox.id) === -1) {
                dict[type].push(checkbox.id);
            }
        }
    } else {
        if (dict[type] !== null) {
            let pos = dict[type].indexOf(checkbox.id);
            if (pos !== -1) {
                dict[type].splice(pos, 1);
                if (dict[type].length === 0) {
                    dict[type] = null;
                }
            }
        }
    }
    window.location.search = buildQueryUrl(dict);
}

/*
 * For search bar and price inputs, replaces URL value with the input value, same way as checkboxClick().
 */
function valueInput(input, type) {
    let dict = dictFromParams();
    dict[type] = [input.value];
    window.location.search = buildQueryUrl(dict);
}

/* 
 *This runs on page load, updates filter/search value to those in the query url 
 */
$(document).ready(function() {
    let queryParams = dictFromParams();
    PARAMS.forEach(function(paramName) {
        if (queryParams[paramName] !== null) {
            queryParams[paramName].forEach(function(paramValue) {
                let element = document.getElementById(paramValue);
                if (element !== null) {
                    element.checked = true;
                } else {
                    element = document.getElementById(paramName);
                    element.value = paramValue;
                }
            });
        }
    });
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