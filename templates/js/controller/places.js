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

	console.log("0");

	$scope.getPosition = function(){
		console.log("1");

		getLocation(function(position){
			console.log("2");
			location_data = {name: $scope.placeName, geo_location: {lat: position.coords.latitude, lon: position.coords.longitude}};
			console.log("3");
			ajax_add_place(location_data);
			console.log("4");
			}
		);
	};
});