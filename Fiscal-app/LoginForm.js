import React, {Component} from 'react';
import {
	ScrollView,
	Text,
	TextInput,
	View,
	Button,
	StyleSheet,
	TouchableOpacity,
	KeyboardAvoidingView,
	StatusBar
} from 'react-native';


export default class LoginForm extends Component {

	render(){
		return(
				<View>
					<KeyboardAvoidingView behavior="padding" style = {styles.container}>

						<TextInput 
							style={styles.inputs} 
							returnKeyType = "next"
							placeholder = "Email" 
							keyboardType = "email-address"
							autoCapitalazi = "none"
							autoCorrect = {false}
							onSubmitEditing={() => this.passwordInput.focus()}
							/>

						<TextInput 
							secureTextEntry
							returnKeyType="go"
							style={styles.inputs}  
							placeholder = 'Password' 
							ref={(input) => this.passwordInput = input}
							/>
						
						<TouchableOpacity 
								style={styles.buttonContainer}
								onPress = { this.props.onLoginPress}>
								<Text 
									style = {styles.buttonText}
								>
									Login
								</Text>
						</TouchableOpacity>
					</KeyboardAvoidingView>

				</View>
				)
	}

}

const styles = StyleSheet.create({
  container: {
    padding:20,
    backgroundColor:'rgba(244,247,251,1)'
  },
  textContainer:{
  	alignItems:'center',
  	flexGrow:1,
  	justifyContent: 'center'
  },
  title:{
  	marginTop:10,
  	width:160,
  	textAlign:'center',
  	fontSize:40,
  	marginBottom:100
  },
  inputs:{
  	height:40,
  	backgroundColor: 'rgba(70,70,70,0.3)',
  	marginBottom:20,
  	paddingHorizontal:10,
  },
  buttonContainer:{
  	paddingVertical:15,
  	backgroundColor:'#2980b9',
  	borderRadius:20
  },
  buttonText:{
  	textAlign:'center',
  	color:'#ffffff'
  }
});