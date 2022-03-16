Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42BF023B2
	for <nvdimm@lists.linux.dev>; Wed, 16 Mar 2022 05:30:52 +0000 (UTC)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22G5QUBo030966;
	Wed, 16 Mar 2022 05:30:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=INav+GgJ9/k9dq6rdd9vV8GzHxbXKLrdkCAThMO0lDs=;
 b=jcmZnEiVe0ieH4GT08OwdFQQwjhmfnlB0JxrEzaDK/Fxq99YSbUqZv3Tek1NqTkRSD8Q
 0SDns92SW8iL4cOnEVG5yuxqyOeRWCc9TX6oPFkWB12P5GHGflxrtwfV6o3HnHiAt//Z
 82GO7zvm9bq/Gerj0qUAwwq3x9zQMcIK2ovhpw0yUN60YpN/QsneW+szZ+9DTggCXns0
 lliCr1c5wYis5lQjXS/mdSQrWUu5j9DALNwfCT9CI2UNnRLGqZVZqpxEZfvuDmILgZmE
 wre+6PTknw9boNGb4APe8mIwDYYLzvAMJ7Ar+Z38JtLVNJpGsh/EK464LuLdjfqeglSK Dw== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
	by mx0b-001b2d01.pphosted.com with ESMTP id 3eu9rf0199-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Mar 2022 05:30:49 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
	by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22G5NMMo026808;
	Wed, 16 Mar 2022 05:30:42 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
	by ppma03fra.de.ibm.com with ESMTP id 3erk58pwx3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Mar 2022 05:30:41 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
	by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22G5Ucuj49414640
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Mar 2022 05:30:38 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 08A3942049;
	Wed, 16 Mar 2022 05:30:38 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6016942042;
	Wed, 16 Mar 2022 05:30:33 +0000 (GMT)
Received: from vajain21.in.ibm.com (unknown [9.163.24.100])
	by d06av24.portsmouth.uk.ibm.com (Postfix) with SMTP;
	Wed, 16 Mar 2022 05:30:32 +0000 (GMT)
Received: by vajain21.in.ibm.com (sSMTP sendmail emulation); Wed, 16 Mar 2022 11:00:31 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: nvdimm@lists.linux.dev
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Shivaprasad G Bhat <sbhat@linux.ibm.com>
Subject: [ndctl PATCH] ndctl/build: Fix 'iniparser' includes due to variances in distros
Date: Wed, 16 Mar 2022 11:00:30 +0530
Message-Id: <20220316053030.2954642-1-vaibhav@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: cCvykGFur0KiDAvPR0sUyVOlMrwrrZfM
X-Proofpoint-ORIG-GUID: cCvykGFur0KiDAvPR0sUyVOlMrwrrZfM
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-16_01,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 adultscore=0 clxscore=1015 priorityscore=1501 impostorscore=0 phishscore=0
 malwarescore=0 lowpriorityscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203160036

The location of 'iniparser' header-files varies from distro to distro. For
example on Centos/Fedora/RHEL they are located at /usr/include/iniparser with
soft-links to the individual header files located at /usr/include. On
Ubuntu/Debian no such soft-links are present at /usr/include. In case of Arch
the files are located at /usr/include itself. This results in build breaks on
distros where iniparser headers aren't located in /usr/include.

Fixing this issue presents a challenge as iniparser's Makefile [1] hasn't
standardized on a specific location for these headers hence distros are free to
pickup a location.

The patch tries to address this problem by updating meson.build to check the
default include-directory (/usr/include/) for iniparser header files
{iniparser.h,dictionary.h} and if not found there then look into
'/usr/include/iniparser'.

Also a new meson build option 'iniparserdir' is introduced that user can used to
point to the directory where the header files are located.

Once the header-files/library are located successfully the 'iniparser' dependency
is updated to have 'include_directories' point to the correct include directory.

Testing
------------
Tested on Fedora-35 under these scenarios:

* iniparser header files not available : Meson Config Faile
* iniparser header files only located at /usr/include/iniparser : Build Succeeded
* iniparser header files only located at /usr/include  : Build Succeeded
* iniparser header files located at /usr/include/iniparser with soft-links
  to headers present at /usr/include  : Build Succeeded
* iniparser header files located at a custom location : Build Succeeded
* iniparser header files located at a custom location which doesn't exists :
  Meson Config Failed
* iniparser headers custom location missing 'dictionary.h' : Meson Config Failed

[1] https://github.com/ndevilla/iniparser/blob/master/Makefile

Fixes: addc5fd8511("Fix iniparser.h include")
Reported-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
---
 meson.build       | 22 ++++++++++++++++++++--
 meson_options.txt |  2 ++
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/meson.build b/meson.build
index 42e11aa25cba..252741528c75 100644
--- a/meson.build
+++ b/meson.build
@@ -158,9 +158,27 @@ endif
 
 cc = meson.get_compiler('c')
 
-# keyutils and iniparser lack pkgconfig
+# keyutils lacks pkgconfig
 keyutils = cc.find_library('keyutils', required : get_option('keyutils'))
-iniparser = cc.find_library('iniparser', required : true)
+
+# iniparser lacks pkgconfig and its header files are either at '/usr/include' or '/usr/include/iniparser'
+# Use the path provided by user via meson configure -Diniparserdir=<somepath>
+# if thats not provided then try searching for 'iniparser.h' in default system include path
+# and if that not found then as a last resort try looking at '/usr/include/iniparser'
+iniparser_headers = ['iniparser.h', 'dictionary.h']
+
+message('Looking for iniparser include headers', iniparser_headers)
+
+iniparserdir = include_directories(includedir / get_option('iniparserdir'), is_system:true)
+iniparser = cc.find_library('iniparser', required : (get_option('iniparserdir') != '') ,
+	  has_headers :iniparser_headers ,header_include_directories : iniparserdir)
+
+if not iniparser.found()
+   iniparserdir = include_directories(includedir / 'iniparser', is_system:true)
+   iniparser = cc.find_library('iniparser', required : true, has_headers : iniparser_headers,
+	     header_include_directories : iniparserdir)
+endif
+iniparser = declare_dependency(include_directories: iniparserdir, dependencies:iniparser)
 
 conf = configuration_data()
 check_headers = [
diff --git a/meson_options.txt b/meson_options.txt
index aa4a6dc8e12a..f7491969f5e0 100644
--- a/meson_options.txt
+++ b/meson_options.txt
@@ -23,3 +23,5 @@ option('pkgconfiglibdir', type : 'string', value : '',
        description : 'directory for standard pkg-config files')
 option('bashcompletiondir', type : 'string',
        description : '''${datadir}/bash-completion/completions''')
+option('iniparserdir', type : 'string',
+       description : 'Path containing the iniparser header files')

base-commit: dd58d43458943d20ff063850670bf54a5242c9c5
prerequisite-patch-id: 85adfc17cde2ef48dc02711966881bd4f3f3f7c3
-- 
2.35.1

