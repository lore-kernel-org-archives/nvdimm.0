Received: from mout.web.de (mout.web.de [212.227.15.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE66EED5
	for <nvdimm@lists.linux.dev>; Sat, 15 Apr 2023 07:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de; s=s29768273;
	t=1681545200; i=markus.elfring@web.de;
	bh=JoxfQRTxfFrS4QMJ+gGO9s1yszcs5J8QcIxbqFfg8NA=;
	h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FsBhHhYCM9OqiLQl37W2WeAf4PF6FwK/niZ1dFpHOvYh6SfhuewMh/WHYff/8I+pm
	 W5PBBnezHijytH2bwoQNX/aY6sQINW9RCgiRMpaCyrXnaRMF0cqH3qAVQRbykn0SGB
	 fWnxsUopxaoipMIkyti8+N6HCByEfAQJeWI3VSKLzTWK+8YFyqmcMjHZKjnbAJLa8/
	 D/BSZ6c/iWUdEMRp0t4Id71PqcMOUVuFQMLTiVydGVCpRrL/+B8GoD5Gr/sTDe2fcA
	 H25EC3QJQ5a9ghdfN4J5BZjkmk3bfmXEAIKYx4aDzQhiYl70JFuX6j4rn7Bm4LK/K0
	 6pgCVBe9sKd0A==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.85.83]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MaHSb-1ptJBt2CxB-00W9Uc; Sat, 15
 Apr 2023 09:53:20 +0200
Message-ID: <32f45d48-f369-ab9a-a9e4-f0ec858b0c97@web.de>
Date: Sat, 15 Apr 2023 09:52:54 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: nvdimm: Replace the usage of a variable by a direct function call
 in nd_pfn_validate()
To: Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev
Cc: kernel-janitors@vger.kernel.org,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Ira Weiny <ira.weiny@intel.com>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Vishal Verma <vishal.l.verma@intel.com>, cocci@inria.fr,
 LKML <linux-kernel@vger.kernel.org>
References: <40c60719-4bfe-b1a4-ead7-724b84637f55@web.de>
 <1a11455f-ab57-dce0-1677-6beb8492a257@web.de>
 <d2403b7a-c6cd-4ee9-2a35-86ea57554eec@web.de>
 <ZDlvunCNe9yWykIE@aschofie-mobl2>
 <88f4dd20-4159-2b66-3adc-9a5a68f9eec7@web.de>
 <ZDmmMhFTg5TaikRl@aschofie-mobl2>
Content-Language: en-GB
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <ZDmmMhFTg5TaikRl@aschofie-mobl2>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:2T4LcFGd0vhKS5AEbKrurCTLQYrvJKt3WG+HSlAjcy/du4q7uf2
 YZqzcTkfse0ngJGyKCdEF9Jakp3qM88oGmWmTveoNBuL+N5tzAbpQnrr12D7pp0FxBVsiNz
 70NxI778qVrkRmXjOOaKRPVIKgCVJi79GLww5ZBEGjhz5WradruGuoRrX9PqJdDsKrs/XQp
 NQQuJSr42Z02dBqDfC9IQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:1zULlK3cMyo=;COXQwCOl6Wpl7GVACTwXYbV386X
 NyJe06hp9+ghukTJjFBLpLHdCvZKhDR680SBb/GR/zZECHvP5XBG9ncPcHmMaZGfS0qURKUbh
 o0P6dPTDhVgle8JvNuil6lp4H2+opb9bqD738oBmDnlgbmJR7mAKu7AL2LYDAcPyE9bJREI8m
 SYxdc0vZdh73yqa31rM6LlaYHEiNqeZeTmhAf6kci/QsaiUDJ9HYbp75nMZk5QHKet3FHP/QI
 OVgq9wLRRokGV/2E2ffDX352+oxm41K4wUwge1OM3YmUaXPtdmZh+vdaNqSEQlBmpwFZ6MAaI
 2u0zStIhDIhRoV6/LJhhccMTPBOOHUs24AQ1L6JjmD90iV8u50Avy4Aj6qvFX+hX/XR7qCLsX
 olkbZ6bJGrMJVvXv+uSf3Tu79xbW8qo2wY7+Q9Sr13dvA0DYA1sdSOIVkzY3BBHo8eS4bqbsE
 ogZpawgHgw37NWYwjR6z6SGGHuwZqEhJjTcVYLBGGm89osey5oULM2cC8vSYyxe5/Ft6NliTp
 Q9zEbjB5Tpsib2bZOIMPCvKLgtiEBOE3Uzg9c6W2bxbwtSkMZVkClgXrhvPbkDjcwOwfOXzH9
 RHWVujwaZgZrfUebqDhP6z+lGmRMQ2gKxKNUMRmL2kT9yHLAHVnmkYTqgIbu8pskQab/QenSl
 Wn+oY8Dc3t9iDnn6t3hHx7hr/Ik83IREXF5bdfTVySFaLQTuHkfWxbxwRAZLqJIrqVxrdvM+9
 jDznT7LHUK5CSlpXZW8QhU74DLYOKj3+q2RH8Bh5Mn0GtQTLJ0LjTiSio0W32M/VN2r/0U2NI
 h6CIlyWVh8BRaWUG9n39hROI48IEHOmsgxdd1t/fpcJ5Vd9jPcDXA/kBsSIBQQr5t/C7bzRhK
 u3y2lQveayhOe9edmu8xvL+6L+Uot+BDyzU75hGQtfvy8jGRDaFyH3kDA

> FYI - I'm a tiny bit taken aback that in response to me applying,
> and providing feedback, on your patch,

This will probably trigger collateral evolution, won't it?


> you respond with 2 links for me to follow

I offered another bit of background information according to your enquiry.


> and cut off a chunk of my feedback.

Will this part become relevant for a subsequent patch?


> Seems like it would taken the same amount of time to just answer my
> two questions directly.

Do you find linked information sources also helpful?


> Was this part of a larger patch set?

Not for this software module.

But one of my scripts for the semantic patch language pointed several upda=
te candidates out.
Thus I sent 19 patches according to these change possibilities so far.
(Would you become interested to take another look by the means of mailing =
list archives?)


> Andy's comment seems to indicate that.

Andy Shevchenko was informed because he is involved also in the evolution =
of other components.


>>> What is the risk of undefined behavior?
>>
>> See also:
>> https://wiki.sei.cmu.edu/confluence/display/c/EXP34-C.+Do+not+dereferen=
ce+null+pointers?focusedCommentId=3D405504137#comment-405504137
>
> Where is the NULL pointer dereference here?

I hope that you can become more aware that access attempts for data struct=
ure members
(also by using the arrow operator) can occasionally be problematic before =
null pointer checks.



>>>> This issue was detected by using the Coccinelle software.
>>> Which cocci script?
>>
>> See also:
>> Reconsidering pointer dereferences before null pointer checks (with SmP=
L)
>> https://lore.kernel.org/cocci/1a11455f-ab57-dce0-1677-6beb8492a257@web.=
de/
>> https://sympa.inria.fr/sympa/arc/cocci/2023-04/msg00021.html
>
> The cocci script linked above does not seem to apply here.

Which command did you try out?

Do you find the following data processing result reasonable?

Markus_Elfring@Sonne:=E2=80=A6/Projekte/Linux/next-analyses> spatch =E2=80=
=A6/Projekte/Coccinelle/janitor/show_pointer_dereferences_before_check7.co=
cci drivers/nvdimm/pfn_devs.c
=E2=80=A6
@@ -456,9 +456,7 @@ int nd_pfn_validate(struct nd_pfn *nd_pf
        unsigned long align, start_pad;
        struct nd_pfn_sb *pfn_sb =3D nd_pfn->pfn_sb;
        struct nd_namespace_common *ndns =3D nd_pfn->ndns;
-       const uuid_t *parent_uuid =3D nd_dev_to_uuid(&ndns->dev);

-       if (!pfn_sb || !ndns)
                return -ENODEV;

        if (!is_memory(nd_pfn->dev.parent))


Regards,
Markus
