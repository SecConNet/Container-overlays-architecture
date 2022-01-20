from statistics import mean
import sys
import os
def average(exp,bunch,folder,mix,overlay):
 exp=exp
 bunch=int(bunch)
 folder=folder
 sum_container = []
 sum_overlay = []
 sum_transfer = []
 sum_total = []
 sum_instant = []
 for num in range(1,bunch):
     if os.path.exists("/home/sshakeri/master/"+str(overlay)+"/request/"+str(folder)+"/duration/container-req"+str(num)+"-bunch"+str(bunch)+"-mix"+str(mix)+"-exp"+str(exp)+".txt"):
         try:
          for line in open("/home/sshakeri/master/"+str(overlay)+"/request/"+str(folder)+"/duration/container-req"+str(num)+"-bunch"+str(bunch)+"-mix"+str(mix)+"-exp"+str(exp)+".txt","r"):
           sum_container.append(float(line))
         except:
          with open ("/home/sshakeri/master/averagelog.txt",'a') as f:
              f.write("container-req"+str(num)+"-bunch"+str(bunch)+"-mix"+str(mix)+"-exp"+str(exp)+".txt does not exist")
     if os.path.exists("/home/sshakeri/master/"+str(overlay)+"/request/"+str(folder)+"/duration/overlay-req"+str(num)+"-bunch"+str(bunch)+"-mix"+str(mix)+"-exp"+str(exp)+".txt"):
         try:
          for line in open("/home/sshakeri/master/"+str(overlay)+"/request/"+str(folder)+"/duration/overlay-req"+str(num)+"-bunch"+str(bunch)+"-mix"+str(mix)+"-exp"+str(exp)+".txt","r"):
            sum_overlay.append(float(line))
         except:
          with open ("/home/sshakeri/master/averagelog.txt",'a') as f:
              f.write("overlay-req"+str(num)+"-bunch"+str(bunch)+"-mix"+str(mix)+"-exp"+str(exp)+".txt does not exist")
     if os.path.exists("/home/sshakeri/master/"+str(overlay)+"/request/"+str(folder)+"/duration/transfer-req"+str(num)+"-bunch"+str(bunch)+"-mix"+str(mix)+"-exp"+str(exp)+".txt"):
         try:
          for line in open("/home/sshakeri/master/"+str(overlay)+"/request/"+str(folder)+"/duration/transfer-req"+str(num)+"-bunch"+str(bunch)+"-mix"+str(mix)+"-exp"+str(exp)+".txt","r"):
            sum_transfer.append(float(line))
         except:
          with open ("/home/sshakeri/master/averagelog.txt",'a') as f:
              f.write("transfer-req"+str(num)+"-bunch"+str(bunch)+"-mix"+str(mix)+"-exp"+str(exp)+".txt does not exist")
     if os.path.exists("/home/sshakeri/master/"+str(overlay)+"/request/"+str(folder)+"/duration/total-req"+str(num)+"-bunch"+str(bunch)+"-mix"+str(mix)+"-exp"+str(exp)+".txt"):
         try:
          for line in open("/home/sshakeri/master/"+str(overlay)+"/request/"+str(folder)+"/duration/total-req"+str(num)+"-bunch"+str(bunch)+"-mix"+str(mix)+"-exp"+str(exp)+".txt","r"):
            sum_total.append(float(line))
         except:
          with open ("/home/sshakeri/master/averagelog.txt",'a') as f:
              f.write("total-req"+str(num)+"-bunch"+str(bunch)+"-mix"+str(mix)+"-exp"+str(exp)+".txt does not exist")
     #if os.path.exists("/home/sshakeri/master/"+str(overlay)+"/request/"+str(folder)+"/duration/policy-req"+str(num)+"-bunch"+str(bunch)+"-mix"+str(mix)+"-instant-exp"+str(exp)+".txt"):
      #   try:
       #    for line in open("/home/sshakeri/master/"+str(overlay)+"/request/"+str(folder)+"/duration/policy-req"+str(num)+"-bunch"+str(bunch)+"-mix"+str(mix)+"-instant-exp"+str(exp)+".txt","r"):
        #     sum_instant.append(float(line))
        # except:
        #  with open ("/home/sshakeri/master/averagelog.txt",'a') as f:
         #     f.write("policy-req"+str(num)+"-bunch"+str(bunch)+"-mix"+str(mix)+"-instant-exp"+str(exp)+".txt does not exist")
 file= open ("/home/sshakeri/master/"+str(overlay)+"/request/"+str(folder)+"/duration/average-container-bunch"+str(bunch)+"-mix"+str(mix)+"-exp"+str(exp)+".txt","w")
 averag = mean(sum_container)
 print(averag)
 file.write(str(averag))
 file.close()
 file= open ("/home/sshakeri/master/"+str(overlay)+"/request/"+str(folder)+"/duration/average-overlay-bunch"+str(bunch)+"-mix"+str(mix)+"-exp"+str(exp)+".txt","w")
 averag = mean(sum_overlay)
 print(averag)
 file.write(str(averag))
 file.close()
 file= open ("/home/sshakeri/master/"+str(overlay)+"/request/"+str(folder)+"/duration/average-transfer-bunch"+str(bunch)+"-mix"+str(mix)+"-exp"+str(exp)+".txt","w")
 averag = mean(sum_transfer)
 print(averag)
 file.write(str(averag))
 file.close()
 file= open ("/home/sshakeri/master/"+str(overlay)+"/request/"+str(folder)+"/duration/average-total-bunch"+str(bunch)+"-mix"+str(mix)+"-exp"+str(exp)+".txt","w")
 averag = mean(sum_total)
 print(averag)
 file.write(str(averag))
 file.close() 
 #file= open ("/home/sshakeri/master/"+str(overlay)+"/request/"+str(folder)+"/duration/average-instant-bunch"+str(bunch)+"-mix"+str(mix)+"-exp"+str(exp)+".txt","w")
 #averag = mean(sum_instant)
 #print(averag)
 #file.write(str(averag))
 #file.close()
if __name__ == '__main__':
      if len(sys.argv) < 5:
        print("Usage: python3  <Experiment number> <Bunch number> <folder> <mix_number> <overlay>")
      else:
        exp = sys.argv[1]
        bunch = sys.argv[2]
        folder= sys.argv[3]
        mix=sys.argv[4]
        overlay=sys.argv[5]
        average(exp, bunch,folder,mix,overlay)
