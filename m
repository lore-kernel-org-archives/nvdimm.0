Received: from mout.web.de (mout.web.de [217.72.192.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D86C7C
	for <nvdimm@lists.linux.dev>; Fri, 14 Apr 2023 16:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de; s=s29768273;
	t=1681491079; i=markus.elfring@web.de;
	bh=7nD+hEQaPjnww32CWdc/UR1nStO0xW9DOusf4LVwQNQ=;
	h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
	b=M6OsQoz23eBPz/1N7QpvDOsXXtowmrywPuLVamntpVSNVfxzcd8+Y9hpdZzoWD48T
	 kjrqc8k+8LoPdexeRC915pgmgVQrXSloqKYkAL/WK1D2tk4mj9QXEiRr31WaQl+lkC
	 LAJLjQwepL4oQMPlnzPq7QjtpkzTccsAGM+PMCq+DApVry0n+hOeDSONCy2sI1OO0C
	 +ycSh1Bf5xs7HO/L8jA7vTWgf+p7xoZNHM48UQHFW3ibYmwd/UGOlLz89TspuuWRf6
	 GoHVX1JrPr6HXw7DSv8rFAS2sGTy6aqp5cFXjocwRQ9Y5fxQq0VANRl2FD0gG4zGQy
	 sWUSKHwavsQBw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.85.83]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1M3m5B-1pndtE2Oyh-000c7R; Fri, 14
 Apr 2023 18:51:19 +0200
Message-ID: <88f4dd20-4159-2b66-3adc-9a5a68f9eec7@web.de>
Date: Fri, 14 Apr 2023 18:50:59 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] nvdimm: Replace the usage of a variable by a direct
 function call in nd_pfn_validate()
To: Alison Schofield <alison.schofield@intel.com>,
 kernel-janitors@vger.kernel.org, nvdimm@lists.linux.dev,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Ira Weiny <ira.weiny@intel.com>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Vishal Verma <vishal.l.verma@intel.com>
Cc: cocci@inria.fr, LKML <linux-kernel@vger.kernel.org>
References: <40c60719-4bfe-b1a4-ead7-724b84637f55@web.de>
 <1a11455f-ab57-dce0-1677-6beb8492a257@web.de>
 <d2403b7a-c6cd-4ee9-2a35-86ea57554eec@web.de>
 <ZDlvunCNe9yWykIE@aschofie-mobl2>
Content-Language: en-GB
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <ZDlvunCNe9yWykIE@aschofie-mobl2>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Th2Vsng4IBnqMEGxDs5NLMWicod2yCw5AlSUK1+Qflo/78XeEFv
 7Psgibs+exN0g0PXs1R94UkZbO24fUu9ZoFj06lqWa6eEeAbqxyRg20tKPNrME6RVLl3pNr
 iOgDclbyPinwzJOtXK5xjVegSIP10k/LOjrHbzF305U4y/dxNkupkFikGuIpjSnmHIRqBqK
 I2IuvDFCGKFgrO9zZnemA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:M/nWoDIxv50=;0mCNXib4bKkw1/b34M049Hi5goY
 KihL+6gd2Et/8D5yYeBqaPetLLxzfvh8rYXh3ddMmRdGRlAhijTAYaBZ7/5wlCy+Gu6lgjEgM
 v3wQ+6Tsf89bHi3KigVp/GNJVYJzITFJa7ex++rDgvMRI4wTEmTv3cg9Sta7osGtrBvDCRzi7
 dEDrmG4KVjKzrsD6jsJS3XfTKLyp26aCfAA+7Cj7iXvGwSDxOIV+y0lOs3KLgCZ5zwwARjf7y
 InXwNPFEMxvLs4p3nk6MzKrZ5wKbm3v6a7FOx2Y38tVnhBB7119VWSPLHHgDdmIbMpgwkD6C/
 clwLx09v0OxLqrZRUT0pMOXUw0rlhNdPdunsq5eBvG8H/TjEdNKEOh6Q5TBgkLWlOm6pQyx0o
 mDT2J8z8Tzp9q9l2X+QAVkEn1e9WjOfmsZ6nP5sT4JWmeRBpg/gXu6V1XvJSnPN12JqZ0J/Zy
 xQCmodR3oBgMy8q2Y+zqOru8GTQBeNWGuKcjgzqeG7jGIuRGGyCtR5eh8jILRTr6din4JUIrR
 ssNFdBoPL4umqL2uN83ba7mqnV6DgoYQD13BP4XxDdFJ47ixdv/JaeqFLCbAt3UyJ35SPr2gU
 BO7hZSFHGfHFKS9jYKD3YJT+av8T3nK5A1eOZo8VTZ5UDteNSIXLdA/l9Hl9Un/Uk3IIKQqcx
 2UsOxshok+SlTN20DKZt3bWFc9TYqgDXBEPD5TXMOBcoAVSZ+tgEJ1rZNVypvGOHFP1kd61eV
 sE2y3xqmqG3EPNzjlx1u37u03HiE1q3QrW5EALi+MEiDaAUOJCES27Ck4KdT+CemXPvEhFcLy
 FpMvEYVihEnPwM9wpjPuq7w5pdR+tGU/u1LNHz0YK8Ojk7Rf57Pl3itwYEJwkCm1CPbsFSOeE
 PKpao394P/keV1kVc5cnp4/ShjmYkCqoHmjwV3Wz/ugZ3qfgZlmnnrUel

>> The address of a data structure member was determined before
>> a corresponding null pointer check in the implementation of
>> the function =E2=80=9Cnd_pfn_validate=E2=80=9D.
>>
>> Thus avoid the risk for undefined behaviour by replacing the usage of
>> the local variable =E2=80=9Cparent_uuid=E2=80=9D by a direct function c=
all within
>> a later condition check.
>
> Hi Markus,
>
> I think I understand what you are saying above, but I don't follow
> how that applies here. This change seems to be a nice simplification,
> parent_uuid, is used once, just grab it when needed.

Thanks for your positive feedback.


> What is the risk of undefined behavior?

See also:
https://wiki.sei.cmu.edu/confluence/display/c/EXP34-C.+Do+not+dereference+=
null+pointers?focusedCommentId=3D405504137#comment-405504137


>> This issue was detected by using the Coccinelle software.
> Which cocci script?

See also:
Reconsidering pointer dereferences before null pointer checks (with SmPL)
https://lore.kernel.org/cocci/1a11455f-ab57-dce0-1677-6beb8492a257@web.de/
https://sympa.inria.fr/sympa/arc/cocci/2023-04/msg00021.html


How do you think about to review and improve any similarly affected softwa=
re components?

Regards,
Markus
