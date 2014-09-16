var mapChallange = angular.module('mapChallange', []);

mapChallange.controller('PlacesList', function($scope, $http) {
	$http({
		method: 'GET',
		url: 'get_places',
	}).success(function(data, status){
		$scope.places = data.places;
	}).error(function(data, status){
		alert(data);
	})
});