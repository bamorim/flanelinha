import React, {Component} from 'react';
import {
	Text,
	TextInput,
	View,
	TouchableOpacity,
	StyleSheet,
	ScrollView
} from 'react-native';

export default class Secured extends Component {
	state = {
		names: [
		   {'name': 'LRK-8421', 'id': 1},
		   {'name': 'LRK-8421', 'id': 1},
		   {'name': 'LRK-8421', 'id': 1},
		   {'name': 'LRK-8421', 'id': 1},
		   {'name': 'LRK-8421', 'id': 1},
		]
	 }
	render(){
		return(
			<View style = {styles.container}>
				<View style = {styles.textContainer}>
					<Text style={styles.title}>
						Estacionamento #{Math.floor(Math.random()*100)+1}
					</Text>
					<Text style={styles.subtitle}>
						Placa do carro
					</Text>
				</View>
				<View style = {styles.placas}>
				<TextInput 
					style={styles.inputs} 
					returnKeyType = "next"
					placeholder = "ABC" 
					keyboardType = "default"
					autoCapitalaze = "words"
					autoCorrect = {false}
					onSubmitEditing={() => this.passwordInput.focus()}
					/>
				<Text>     </Text>
				<TextInput 
					returnKeyType="go"
					keyboardType = "numeric"
					style={styles.inputs}  
					placeholder = '123' 
					ref={(input) => this.passwordInput = input}
					/>
				</View>
				<View>
					<ScrollView>
						{
							this.state.names.map((item, index) => (
							<View key = {item.id} style = {styles.item}>
								<Text style={styles.parados}>{item.name}</Text>
								<TouchableOpacity 
								style={styles.deleteButton}
								onPress = { this.props.onLoginPress}>
								<Text 
									style = {styles.buttonText}
								>
									Delete
								</Text>
								</TouchableOpacity>	
							</View>
							))
						}
					</ScrollView>
				</View>
				<View style={styles.buttonContainer} >
					<TouchableOpacity 
						onPress = { this.props.onLogoutPress}>
						<Text style={styles.buttonText}>
							Logout
						</Text>
					</TouchableOpacity>
				</View>

			</View>

			)
	}
}

const styles = StyleSheet.create({
  item:{
	flexDirection: 'row'
  },
  container: {
    padding:20,
    backgroundColor:'rgba(244,247,251,1)'
  },
  textContainer:{
  	alignItems:'center',
  	flexGrow:1,
  	justifyContent: 'center',
    backgroundColor:'rgba(244,247,251,1)'

  },
  title:{
  	marginTop:10,
  	width:300,
  	textAlign:'center',
  	fontSize:28,
  	marginBottom:30
  },
  subtitle:{
	marginTop:5,
	width:200,
	textAlign:'center',
	fontSize:24,
	marginBottom:50
  },
  inputs:{
  	width: 60,
  	height:40,
  	backgroundColor: 'rgba(70,70,70,0.3)',
  	marginBottom:50,
  	paddingHorizontal:10,
  },
  placas:{
  	flex:1,
  	flexDirection: 'row',
    justifyContent:'center',
  	alignItems:'center',
  	marginBottom: 20
  },
  parados:{
	width: 200,
	fontSize:26,
	marginBottom:30
  },
  buttonContainer:{
  	paddingVertical:15,
  	backgroundColor:'#2980b9',
  	borderRadius:20
  },
  deleteButton:{
  	paddingVertical:15,
  	backgroundColor: 'rgb(230,0,26)',
  	borderRadius:20
  },
  buttonText:{
  	textAlign:'center',
  	color:'#ffffff'
  }
});	