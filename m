Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85591FB7
	for <nvdimm@lists.linux.dev>; Wed, 16 Mar 2022 03:44:57 +0000 (UTC)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22G2fmdj016502;
	Wed, 16 Mar 2022 03:44:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=K61H/I7PCJoIqAiLLlwzAkXA7klFPLUUvQE4S06ijTs=;
 b=LeQgJD+8cC1Guj5PfQngKjxQX8sgTYRFbebH0/MYU/O6wgUy86ZQzIFm1ykTWI0Z9hLX
 SxSBZnqgXh1YuAfdKn0Y+V11FR5l3rVVY7LXPxodtoN3CvYNK9vKSI1ECM6GCF4wpylS
 XQhr29A6nibM+INsbeTY62OJmNC+780O4JxdyzArcyUZjD9osQlg0xaHRcRG2AU1zuCS
 GjAJghdni4h5DKpMzs6gH6CE1BGpjxhbRHdY/XN99Vsm0DW6VZKUonfS3WnA+7IUBBLp
 DNHy1Sw81/AjWWJaGHPVOzzgA5n8uoUDILfqWQPtrUfJ8/TRH4XOtk1EVR9OpnX57ddA ug== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3eu7b1rvn6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Mar 2022 03:44:56 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
	by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22G3hiv8017847;
	Wed, 16 Mar 2022 03:44:54 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
	by ppma06fra.de.ibm.com with ESMTP id 3erjshpsba-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Mar 2022 03:44:54 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
	by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22G3iqnj41615710
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Mar 2022 03:44:52 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D0D8042047;
	Wed, 16 Mar 2022 03:44:50 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A85AE4203F;
	Wed, 16 Mar 2022 03:44:46 +0000 (GMT)
Received: from vajain21.in.ibm.com (unknown [9.163.24.100])
	by d06av24.portsmouth.uk.ibm.com (Postfix) with SMTP;
	Wed, 16 Mar 2022 03:44:46 +0000 (GMT)
Received: by vajain21.in.ibm.com (sSMTP sendmail emulation); Wed, 16 Mar 2022 09:14:44 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>,
        "nvdimm@lists.linux.dev"
 <nvdimm@lists.linux.dev>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
        "aneesh.kumar@linux.ibm.com" <aneesh.kumar@linux.ibm.com>,
        "sbhat@linux.ibm.com" <sbhat@linux.ibm.com>,
        "Weiny, Ira"
 <ira.weiny@intel.com>
Subject: Re: [ndctl PATCH] ndctl,daxctl,util/build: Reconcile 'iniparser'
 dependency
In-Reply-To: <967a55fb5098e61abc697d00123f7aedc9ef7333.camel@intel.com>
References: <20220315162641.2778960-1-vaibhav@linux.ibm.com>
 <967a55fb5098e61abc697d00123f7aedc9ef7333.camel@intel.com>
Date: Wed, 16 Mar 2022 09:14:44 +0530
Message-ID: <87pmmmblxv.fsf@vajain21.in.ibm.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _6Y0P-D82HIBhLcz25mXTboKIPMfNKFA
X-Proofpoint-GUID: _6Y0P-D82HIBhLcz25mXTboKIPMfNKFA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-16_01,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 malwarescore=0 priorityscore=1501 clxscore=1015 lowpriorityscore=0
 phishscore=0 adultscore=0 impostorscore=0 mlxlogscore=999 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203160021

Thanks for looking into this patch Vishal.

"Verma, Vishal L" <vishal.l.verma@intel.com> writes:

> On Tue, 2022-03-15 at 21:56 +0530, Vaibhav Jain wrote:
>> This trivial patch updates 'meson.build' files for daxctl, ndctl to
>> remove
>> explicit dependency on 'iniparser'. Instead util/meson.build is
>> updated to add a
>> dependency to 'iniparser' which than get tricked to daxctl, ndctl via
>
> s/tricked/trickled/
Addressed this in V2 of the patch. Thanks for pointing this out.

>
> Otherwise looks good to me.
>
>> 'util_dep'
>> dependency.
>>=20
>> Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
>> ---
>> =C2=A0daxctl/meson.build | 1 -
>> =C2=A0ndctl/meson.build=C2=A0 | 1 -
>> =C2=A0util/meson.build=C2=A0=C2=A0 | 1 +
>> =C2=A03 files changed, 1 insertion(+), 2 deletions(-)
>>=20
>> diff --git a/daxctl/meson.build b/daxctl/meson.build
>> index ec2e2b648d40..8474d02f2c0d 100644
>> --- a/daxctl/meson.build
>> +++ b/daxctl/meson.build
>> @@ -15,7 +15,6 @@ daxctl_tool =3D executable('daxctl',
>> =C2=A0=C2=A0 dependencies : [
>> =C2=A0=C2=A0=C2=A0=C2=A0 daxctl_dep,
>> =C2=A0=C2=A0=C2=A0=C2=A0 ndctl_dep,
>> -=C2=A0=C2=A0=C2=A0 iniparser,
>> =C2=A0=C2=A0=C2=A0=C2=A0 util_dep,
>> =C2=A0=C2=A0=C2=A0=C2=A0 uuid,
>> =C2=A0=C2=A0=C2=A0=C2=A0 kmod,
>> diff --git a/ndctl/meson.build b/ndctl/meson.build
>> index 6a3d0e5348c2..c7889af36084 100644
>> --- a/ndctl/meson.build
>> +++ b/ndctl/meson.build
>> @@ -27,7 +27,6 @@ deps =3D [
>> =C2=A0=C2=A0 uuid,
>> =C2=A0=C2=A0 kmod,
>> =C2=A0=C2=A0 json,
>> -=C2=A0 iniparser,
>> =C2=A0=C2=A0 versiondep,
>> =C2=A0]
>> =C2=A0
>> diff --git a/util/meson.build b/util/meson.build
>> index 784b27915649..695037a924b9 100644
>> --- a/util/meson.build
>> +++ b/util/meson.build
>> @@ -11,6 +11,7 @@ util =3D static_library('util', [
>> =C2=A0=C2=A0 'abspath.c',
>> =C2=A0=C2=A0 'iomem.c',
>> =C2=A0=C2=A0 ],
>> +=C2=A0 dependencies: iniparser,
>> =C2=A0=C2=A0 include_directories : root_inc,
>> =C2=A0)
>> =C2=A0util_dep =3D declare_dependency(link_with : util)
>>=20
>> base-commit: dd58d43458943d20ff063850670bf54a5242c9c5
>

--=20
Cheers
~ Vaibhav
