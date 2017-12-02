import React from 'react';
import { 
  StyleSheet,
  Text,
  View 
} from 'react-native';

import Login from "./Login";
import Secured from "./Secured";

export default class App extends React.Component {
  
  state = {
    isLoggedIn: 0
  }

  render() {
    if(this.state.isLoggedIn)
      return <Secured 
              onLogoutPress = {()=> this.setState({isLoggedIn: 0})}
            />;
    else
      return <Login 
              onLoginPress={()=> this.setState({isLoggedIn: 1})}
            />;
  }
}

// const styles = StyleSheet.create({
//   container: {
//     flex: 1,
//     backgroundColor: '#fff',
//     alignItems: 'center',
//     justifyContent: 'center',
//   },
// });
