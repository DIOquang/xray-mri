"""
Test script for Medical Image Classification API
"""

import requests
import sys

API_URL = "http://localhost:5000"

def test_health():
    """Test health endpoint"""
    print("\n" + "="*60)
    print("Testing /health endpoint...")
    print("="*60)
    
    try:
        response = requests.get(f"{API_URL}/health")
        print(f"Status Code: {response.status_code}")
        print(f"Response: {response.json()}")
        return response.status_code == 200
    except Exception as e:
        print(f"Error: {e}")
        return False


def test_models_info():
    """Test models info endpoint"""
    print("\n" + "="*60)
    print("Testing /models/info endpoint...")
    print("="*60)
    
    try:
        response = requests.get(f"{API_URL}/models/info")
        print(f"Status Code: {response.status_code}")
        data = response.json()
        
        print("\nX-ray Model:")
        for key, value in data['xray_model'].items():
            print(f"  {key}: {value}")
        
        print("\nMRI Model:")
        for key, value in data['mri_model'].items():
            print(f"  {key}: {value}")
        
        return response.status_code == 200
    except Exception as e:
        print(f"Error: {e}")
        return False


def test_predict_xray(image_path):
    """Test X-ray prediction endpoint"""
    print("\n" + "="*60)
    print(f"Testing /predict/xray with image: {image_path}")
    print("="*60)
    
    try:
        with open(image_path, 'rb') as f:
            files = {'file': f}
            response = requests.post(f"{API_URL}/predict/xray", files=files)
        
        print(f"Status Code: {response.status_code}")
        
        if response.status_code == 200:
            data = response.json()
            print(f"\nPrediction: {data['prediction']}")
            print(f"Confidence: {data['confidence']}%")
            print(f"\nProbabilities:")
            for class_name, prob in data['probabilities'].items():
                print(f"  {class_name}: {prob}%")
        else:
            print(f"Error: {response.json()}")
        
        return response.status_code == 200
    except Exception as e:
        print(f"Error: {e}")
        return False


def test_predict_mri(image_path):
    """Test MRI prediction endpoint"""
    print("\n" + "="*60)
    print(f"Testing /predict/mri with image: {image_path}")
    print("="*60)
    
    try:
        with open(image_path, 'rb') as f:
            files = {'file': f}
            response = requests.post(f"{API_URL}/predict/mri", files=files)
        
        print(f"Status Code: {response.status_code}")
        
        if response.status_code == 200:
            data = response.json()
            print(f"\nPrediction: {data['prediction']}")
            print(f"Confidence: {data['confidence']}%")
            print(f"\nProbabilities:")
            for class_name, prob in data['probabilities'].items():
                print(f"  {class_name}: {prob}%")
        else:
            print(f"Error: {response.json()}")
        
        return response.status_code == 200
    except Exception as e:
        print(f"Error: {e}")
        return False


def main():
    print("\n" + "="*60)
    print("Medical Image Classification API - Test Suite")
    print("="*60)
    
    results = []
    
    # Test 1: Health check
    results.append(("Health Check", test_health()))
    
    # Test 2: Models info
    results.append(("Models Info", test_models_info()))
    
    # Test 3: X-ray prediction (if image path provided)
    if len(sys.argv) > 1:
        xray_image = sys.argv[1]
        results.append(("X-ray Prediction", test_predict_xray(xray_image)))
    
    # Test 4: MRI prediction (if image path provided)
    if len(sys.argv) > 2:
        mri_image = sys.argv[2]
        results.append(("MRI Prediction", test_predict_mri(mri_image)))
    
    # Summary
    print("\n" + "="*60)
    print("TEST SUMMARY")
    print("="*60)
    
    for test_name, result in results:
        status = "✓ PASS" if result else "✗ FAIL"
        print(f"{test_name:.<50} {status}")
    
    passed = sum(1 for _, r in results if r)
    total = len(results)
    print(f"\nTotal: {passed}/{total} tests passed")
    print("="*60 + "\n")
    
    return passed == total


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("\nUsage: python test_api.py <xray_image_path> [mri_image_path]")
        print("\nExample:")
        print("  python test_api.py data/chest_xray/test/NORMAL/image.jpg")
        print("  python test_api.py data/chest_xray/test/NORMAL/image.jpg data/brain_mri/test/glioma/image.jpg")
        print("\nRunning basic tests only...\n")
    
    success = main()
    sys.exit(0 if success else 1)
