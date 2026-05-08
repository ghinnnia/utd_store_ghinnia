class CalculateTaxUseCase {
  int executeHeavyLoop() {
    int result = 0;
    
    // NIM kamu 20123046, ambil 2 digit terakhir yaitu 46 [cite: 41]
    int duaDigitNIM = 46; 
    
    // Looping sebanyak [2 Digit NIM] x 10.000.000 
    int limit = duaDigitNIM * 10000000; 

    for (int i = 0; i < limit; i++) {
      result += 1; // Lakukan operasi matematika agar Isolate bekerja
    }
    
    return result; 
  }
}