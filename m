Received: from mailsrv.cs.umass.edu (mailsrv.cs.umass.edu [128.119.240.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8513653B2
	for <nvdimm@lists.linux.dev>; Thu, 21 Jul 2022 19:14:11 +0000 (UTC)
Received: from [192.168.50.148] (c-24-62-201-179.hsd1.ma.comcast.net [24.62.201.179])
	by mailsrv.cs.umass.edu (Postfix) with ESMTPSA id 6264A4029631;
	Thu, 21 Jul 2022 15:14:10 -0400 (EDT)
Reply-To: moss@cs.umass.edu
To: nvdimm@lists.linux.dev
From: Eliot Moss <moss@cs.umass.edu>
Subject: Building on Ubuntu; and persistence_domain:cpu_cache
Message-ID: <c8297399-4c99-52d9-861a-62fade81cda1@cs.umass.edu>
Date: Thu, 21 Jul 2022 15:14:09 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

Dear NVDimm folk:

I write concerning ndctl verion 72.1+ running on Ubuntu 22.04 (Linux
5.15.0-41-generic x86_64).

The system is a brand new two socket Dell server with cpu model Xeon GOld 6346
and 4 Tb of Optane DC P200 memory.

I am able to ue ndctl to configure the two regions with one namespace each in
fsdax mode.  Here is what ndctl list --namespaces -R prints:

{
   "regions":[
     {
       "dev":"region1",
       "size":2177548419072,
       "align":16777216,
       "available_size":0,
       "max_available_extent":0,
       "type":"pmem",
       "iset_id":-953140445588584312,
       "persistence_domain":"memory_controller",
       "namespaces":[
         {
           "dev":"namespace1.0",
           "mode":"fsdax",
           "map":"dev",
           "size":2143522127872,
           "uuid":"ed74879e-4eb6-4f88-bb7f-ae018d659720",
           "sector_size":512,
           "align":2097152,
           "blockdev":"pmem1",
           "name":"namespace1"
         }
       ]
     },
     {
       "dev":"region0",
       "size":2177548419072,
       "align":16777216,
       "available_size":0,
       "max_available_extent":0,
       "type":"pmem",
       "iset_id":-3109801715871676280,
       "persistence_domain":"memory_controller",
       "namespaces":[
         {
           "dev":"namespace0.0",
           "mode":"fsdax",
           "map":"dev",
           "size":2143522127872,
           "uuid":"64c75dc0-3d7a-4ac0-8698-8914e67b18db",
           "sector_size":512,
           "align":2097152,
           "blockdev":"pmem0",
           "name":"namespace0"
         }
       ]
     }
   ]
}

What concerns me is that it shows "persistence_domain":"memory_controller"
when I think it should show the persistence domain as "cpu_cache", since this
system is supposed to support eADR.

I wondered if maybe I needed the very latest version of ndctl for it to print
that, but I cannot build it.  I did my best to obtain the pre-reqs -- they
mostly have different names under Ubunut -- but the first meson command,
"meson setup build" hangs and if I then try the compile step it complains.

I am hoping someone here might be able to shed light on how I can verify that
this system does support persistence_domain cpu_cache, or if something needs
to be enabled or turned on, etc.  I have also gotten my Dell sales rep to
contact the Dell product engineers about this, but have not yet heard back.

Thanks for any light you might shed on either issue ...

Regards - Eliot Moss
Professor Emeritus, Computer and Information Sciences
Univ of Massachusetts Amherst
