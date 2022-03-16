Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1011D46B4
	for <nvdimm@lists.linux.dev>; Wed, 16 Mar 2022 03:51:02 +0000 (UTC)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22G2fnT7016633;
	Wed, 16 Mar 2022 03:51:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=MrOgQplsmkqevDfGAgHF8kej7or/ShjuxSsG8p12BP4=;
 b=jw0135oK1UhmH5wiBVQG/JkkHy+GYeonC5toJ0UEV2w/ux+E5Wqtd34zdhf9lUVodhP9
 Yix8hjwIl27+o+QFIE45lYmU8F1p6XKEUMHaUUes0rt8I7eVRF+O6w+uOUVBjH2Bw2RZ
 FWicOHfpAweIK80bSZOKiW/bULOZx10mBj/7u5UBWzfs5Lp7WKfINvAtuY8IfC6dGrD7
 lEfwVt4PFh7UOsYapngAT13/LTxVIeAC8Twmf3QA0kzEWaNmRDhkuHlOh1Hr1a9TouCv
 svYSvJ5Udwy5eB7CQHBfqk7Brb7GOdyzwSm9IsQmIbEhrVyMnUazCI0E1nwNLqVbICI8 CA== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3eu7b1ry55-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Mar 2022 03:51:01 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
	by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22G3lXGd026970;
	Wed, 16 Mar 2022 03:50:59 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
	by ppma06ams.nl.ibm.com with ESMTP id 3erjshqwwx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Mar 2022 03:50:59 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
	by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22G3ov3Y30408996
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Mar 2022 03:50:57 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F40D1A404D;
	Wed, 16 Mar 2022 03:50:56 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 898F0A4040;
	Wed, 16 Mar 2022 03:50:55 +0000 (GMT)
Received: from [9.43.109.77] (unknown [9.43.109.77])
	by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Wed, 16 Mar 2022 03:50:55 +0000 (GMT)
Message-ID: <3cada8ec-82aa-33b7-1c10-11a065d9e122@linux.ibm.com>
Date: Wed, 16 Mar 2022 09:20:54 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH] util/parse: Fix build error on ubuntu
Content-Language: en-US
To: Vaibhav Jain <vaibhav@linux.ibm.com>, nvdimm@lists.linux.dev,
        dan.j.williams@intel.com, vishal.l.verma@intel.com
References: <20220315060426.140201-1-aneesh.kumar@linux.ibm.com>
 <874k3zd27b.fsf@vajain21.in.ibm.com> <87v8wfcyht.fsf@linux.ibm.com>
 <87zglrb1tu.fsf@vajain21.in.ibm.com>
From: Aneesh Kumar K V <aneesh.kumar@linux.ibm.com>
In-Reply-To: <87zglrb1tu.fsf@vajain21.in.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: PIJgzi5mowBM8_Ft-vwQQlHJDZ-X9zU8
X-Proofpoint-GUID: PIJgzi5mowBM8_Ft-vwQQlHJDZ-X9zU8
Content-Transfer-Encoding: 7bit
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
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 malwarescore=0 priorityscore=1501 clxscore=1015 lowpriorityscore=0
 phishscore=0 adultscore=0 impostorscore=0 mlxlogscore=999 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203160021

On 3/15/22 10:16 PM, Vaibhav Jain wrote:
> "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com> writes:
> 
>> Vaibhav Jain <vaibhav@linux.ibm.com> writes:
>>
>>> Second hunk of this diff seems to be a revert of [1]  which might
>>> break the ndctl build on Arch Linux.
>>>
>>> AFAIS for Centos/Fedora/RHEL etc the iniparser.h file is present in the
>>> default include path('/usr/include') as a softlink to
>>> '/usr/include/iniparser/iniparser.h' . Ubuntu/Debian seems to an
>>> exception where path '/usr/include/iniparser.h' is not present.
>>>
>>> I guess thats primarily due to no 'make install' target available in
>>> iniparser makefiles [1] that fixes a single include patch. This may have led
>>> to differences across distros where to place these header files.
>>>
>>> I would suggest changing to this in meson.build to atleast catch if the
>>> iniparser.h is not present at the expected path during meson setup:
>>>
>>>      iniparser = cc.find_library('iniparser', required : true, has_headers: 'iniparser.h')
>>>
>>> [1] addc5fd8511('Fix iniparser.h include')
>>> [2] https://github.com/ndevilla/iniparser/blob/master/Makefile
>>
>>
>> We can do this.
>>
>> diff --git a/config.h.meson b/config.h.meson
>> index 2852f1e9cd8b..b070df96cf4a 100644
>> --- a/config.h.meson
>> +++ b/config.h.meson
>> @@ -82,6 +82,9 @@
>>   /* Define to 1 if you have the <unistd.h> header file. */
>>   #mesondefine HAVE_UNISTD_H
>>   
>> +/* Define to 1 if you have the <iniparser/iniparser.h> header file. */
>> +#mesondefine HAVE_INIPARSER_INCLUDE_H
>> +
>>   /* Define to 1 if using libuuid */
>>   #mesondefine HAVE_UUID
>>   
>> diff --git a/meson.build b/meson.build
>> index 42e11aa25cba..893f70c22270 100644
>> --- a/meson.build
>> +++ b/meson.build
>> @@ -176,6 +176,7 @@ check_headers = [
>>     ['HAVE_SYS_STAT_H', 'sys/stat.h'],
>>     ['HAVE_SYS_TYPES_H', 'sys/types.h'],
>>     ['HAVE_UNISTD_H', 'unistd.h'],
>> +  ['HAVE_INIPARSER_INCLUDE_H', 'iniparser/iniparser.h'],
>>   ]
>>   
>>   foreach h : check_headers
>> diff --git a/util/parse-configs.c b/util/parse-configs.c
>> index c834a07011e5..8bdc9d18cbf3 100644
>> --- a/util/parse-configs.c
>> +++ b/util/parse-configs.c
>> @@ -4,7 +4,11 @@
>>   #include <dirent.h>
>>   #include <errno.h>
>>   #include <fcntl.h>
>> +#ifdef HAVE_INIPARSER_INCLUDE_H
>> +#include <iniparser/iniparser.h>
>> +#else
>>   #include <iniparser.h>
>> +#endif
>>   #include <sys/stat.h>
>>   #include <util/parse-configs.h>
>>   #include <util/strbuf.h>
> 
> Agree, above patch can fix this issue. Though I really wanted to avoid
> trickling changes to the parse-configs.c since the real problem is with
> non consistent location for iniparser.h header across distros.
> 
> I gave it some thought and came up with this patch to meson.build that can
> pick up appropriate '/usr/include' or '/usr/include/iniparser' directory
> as include path to the compiler.
> 
> Also since there seems to be no standard location for this header file
> I have included a meson build option named 'iniparser-includedir' that
> can point to the dir where 'iniparser.h' can be found.
> 
> diff --git a/meson.build b/meson.build
> index 42e11aa25cba..8c347e64ca2d 100644
> --- a/meson.build
> +++ b/meson.build
> @@ -158,9 +158,27 @@ endif
>   
>   cc = meson.get_compiler('c')
>   
> -# keyutils and iniparser lack pkgconfig
> +# keyutils lack pkgconfig
>   keyutils = cc.find_library('keyutils', required : get_option('keyutils'))
> -iniparser = cc.find_library('iniparser', required : true)
> +
> +# iniparser lacks pkgconfig and its header files are either at '/usr/include' or '/usr/include/iniparser'
> +# First use the path provided by user via meson configure -Diniparser-includedir=<somepath>
> +# if thats not provided than try searching for 'iniparser.h' in default system include path
> +# and if that not found than as a last resort try looking at '/usr/include/iniparser'
> +
> +if get_option('iniparser-includedir') == ''
> +  iniparser = cc.find_library('iniparser', required : false, has_headers : 'iniparser.h')
> +  # if not available at the default path try '/usr/include/iniparser'
> +  if not iniparser.found()
> +    iniparser = cc.find_library('iniparser', required : true, has_headers : 'iniparser/iniparser.h')
> +    iniparser = declare_dependency(include_directories:'/usr/include/iniparser', dependencies:iniparser)
> +  endif
> +else
> +  iniparser_incdir = include_directories(get_option('iniparser-includedir'))
> +  iniparser = cc.find_library('iniparser', required : true, has_headers : 'iniparser.h',
> +                                            header_include_directories:iniparser_incdir)
> +  iniparser = declare_dependency(include_directories:iniparser_incdir, dependencies:iniparser)
> +endif
>   
>   conf = configuration_data()
>   check_headers = [
> diff --git a/meson_options.txt b/meson_options.txt
> index aa4a6dc8e12a..d08151691553 100644
> --- a/meson_options.txt
> +++ b/meson_options.txt
> @@ -23,3 +23,5 @@ option('pkgconfiglibdir', type : 'string', value : '',
>          description : 'directory for standard pkg-config files')
>   option('bashcompletiondir', type : 'string',
>          description : '''${datadir}/bash-completion/completions''')
> +option('iniparser-includedir', type : 'string',
> +       description : '''Path containing the iniparser header files''')
> 
> 


Looks good. Can you send this as a patch?

-aneesh
