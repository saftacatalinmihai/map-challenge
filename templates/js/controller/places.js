var mapChallange = angular.module('mapChallange', []);
var location_data; 

mapChallange.controller('PlacesList', function($scope, $http) {
	$http({
		method: 'GET',
		url: 'get_places',
	}).success(function(data, status){
		$scope.places = data.places;
	}).error(function(data, status){
		alert(data);
	})

	$scope.updatePlaces = function(){
		$http({
			method: 'GET',
			url: 'get_places',
		}).success(function(data, status){
			$scope.places = data.places;
		}).error(function(data, status){
			alert(data);
		})
	}

	$scope.getPosition = function(){

		getLocation(function(position){

			location_data = {name: $scope.placeName, geo_location: {lat: position.coords.latitude, lon: position.coords.longitude}};

			$http({
				method: 'POST',
				url: 'add_place',
				data: location_data,
				headers: {'Content-Type': 'application/x-www-form-urlencoded'},
			}).success(function(data, status){
				console.log("5");
				$scope.places.push(location_data);
				$scope.placeName = "";
			}).error(function(data, status){
				alert(data);
			})
			}
		);
	};
});