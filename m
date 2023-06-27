Received: from mout.web.de (mout.web.de [212.227.15.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5C918C3B
	for <nvdimm@lists.linux.dev>; Tue, 27 Jun 2023 16:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
 s=s29768273; t=1687882988; x=1688487788; i=markus.elfring@web.de;
 bh=+mg9vo4tC9vA0j1Q0W96cmpjtBvEunLRwGmHXs1tliw=;
 h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
 b=pLj3z7mJ+YMs+cT88roKmEI5qtDXgA/KPRSwENlD1H8+S8Ul0q9a8FICc1BI+0HYeuDDYSR
 GBmUoKnWDGjUZE+mOWNvFhFzpC5A/gG5/l38g0zq4uW5/jfaiDKwhHGErkOu7RhMeaTBMuFKo
 4qzBHu75tb5e+UwNMOeXSymhv+mtD8xuHmFXWZseSRDC8M/+OcmiguFjIX4D70hcPRtrM+k1K
 bos6/hWhhRKMBgTWmNPZJlkizGw6a4W5gjfkKSdqBDMxOeaDWf7KRqzu7v/nQAX1AO+c1mXDZ
 n1Gg3nZ1MSnnv+xncrEqVNsvpdv22R3ngpq8y31eSmcH8l24iEjg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.82.83]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MzCA3-1praPv123P-00w8dE; Tue, 27
 Jun 2023 18:23:08 +0200
Message-ID: <b46b90b5-cc1d-9311-892b-a0f8abe155d6@web.de>
Date: Tue, 27 Jun 2023 18:22:47 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [v5 0/1] dax: enable dax fault handler to report
 VM_FAULT_HWPOISON
To: Matthew Wilcox <willy@infradead.org>, kernel-janitors@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev
Cc: Jane Chu <jane.chu@oracle.com>, LKML <linux-kernel@vger.kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Ira Weiny <ira.weiny@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
References: <20230615181325.1327259-1-jane.chu@oracle.com>
 <b57afc45-6bf8-3849-856f-2873e60fcf97@web.de>
 <18ca0017-821b-595c-0d5a-25adb04196c1@oracle.com>
 <be3db57c-29d0-cfc9-f0cc-1765b672c57e@web.de>
 <ZJr+ngIH877t9seI@casper.infradead.org>
Content-Language: en-GB
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <ZJr+ngIH877t9seI@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:1I6iffXyS2VFfi5s8vlHtcvjwfu0Uj2F4SwKcTlE6SJ7MTwLal/
 luUlv1Bdvt0ax7mWyfszfO7WXCsm8G7ggjl+/+IF+S7Ob1KrYRSNfCmxq+g65Chhc4jfI0c
 8YiGo/GCvcHsftSufddzFvw4VMydNNL9AcnDHdWU9qbfSilIPu1CM5Jz/pxn8NyPDwkmP+1
 l3yP8yhDOTOk905Gv6wSQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:l6ApK51wXM4=;iPnaQl6m3PKcecO0fMpwvEeyxCO
 rBkn4/Kji82Lxf3g7KN4M3yG1YFlX3G6gd2xRCkojM3v9WQJSCEJXK8mGc79nyalMPMbxBy1M
 AHmVfIvtzW3MWM02nbL7HeQxh8RHopduHZdB7qmLPEg8oSr6GBXZUgzLw55K+ii4Sns/+PYEl
 MWRlze2S1ekO1Bf+aWQOpReVLaOrJEBKRuYvXyBerlXPpZKgYqvbgW5t7JhvH8ru8odrYPlSR
 OndrbcI7uOtnNDfCuTZoPaCfQsCosjISGLocZgNnA0rNrDfVXH85OIsJ2fWyWk4GnVZJ04UJz
 palSR9bU3Plc9ei0ESequdqGbtsNYOHu6eD3xgu6PXBRpHvwTnYg3vK3nhpQyovRScwPvuUg9
 vkv6KCuhxmzPrcmJJJBmiub4SGoza2isbFwYeAa4z0SmrT12hgcGyLH7yiBqFzlr5xGv3aJkT
 NmcPm0KVT+XLTp+wR5eH+RF4zi/2ZBzGfRfFeYyF9kZCLD6fuZtMfu5zzXQMafXf6ootfKnRP
 NEKZcvEniTy/xPaRLcT9PJRRRiQb0aQv90a89q+S0sSp2mEiV04DV8asmG14THemn0vVFnUi6
 HrpyCbaC69SOQg1Uy1cIDgOnYibNcgzZHfFu/PfX7H3mYgO61HtCIZ0eFZdfZJXqC5d+ALXMN
 aQICh+6H+FfPMTXyO1mKvYpAV3YsvJbm5sdPC8NqPgxmDfmBH/40ubFHjAlthxTyAZsmOrxXO
 rIoSYChVc7K66Qpa/NLyfvZ0+ihS/S9Lz5BJSvem/IT4Eluk3WJjWOX0j2IjqQHs7uALGcIW+
 CgsytJJ093mwHyURlHagjSdUmF3Bd1mSFkSZCEo7FrXGuotXhlVzk0yczovprBIjgInMkihvn
 7oAO4NaMSDs52iIHeQJj9sGQXMe6OOwN+vzMI7iLoYmFM5aNsEkvs9CvWTvFACorJ2k8BODD6
 p5scigqy5IHTJ6v22bUeIbxHZr0=

>> How do you think about to put additional information below triple dashe=
s
>> (or even into improved change descriptions)?
>>
>> See also:
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree=
/Documentation/process/submitting-patches.rst?h=3Dv6.4#n686
>
> Markus,
>
> Please go away.  Your feedback is not helpful.

Would you insist on the usage of cover letters also for single patches?

Regards,
Markus
