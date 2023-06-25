Received: from mout.web.de (mout.web.de [212.227.15.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A7E7E4
	for <nvdimm@lists.linux.dev>; Sun, 25 Jun 2023 06:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
 s=s29768273; t=1687674348; x=1688279148; i=markus.elfring@web.de;
 bh=TUJ6AJ2v7XKUTPPKKTk5XrEBg5eVwcLL/TAiUqHtLiY=;
 h=X-UI-Sender-Class:Date:To:Cc:References:Subject:From:In-Reply-To;
 b=kKgeS1vkb3m3XeNiwfKes87j7pfUKeraeHj3KYCnYYqDyz/ZZ/IaJyfL8KLob3Vp2EDvEsx
 JAEqBnhZsX20cd+w3nwzg6CZPx48NrahkJq4+E9uy2SocD4F1nrXn5QYtEZiwFv9te2Ar20xi
 SPLZ42ZFKAYaoPUDqRz+or8RkQJCXVQrHvY4EimPcE3L4eIo1ItkwWxEduW63Wgju8/Re/9Xf
 DT/R2wEKS2PiQ+dXMrLKUA2kB4400+Xeili8HhIn92ecdWgRYclpGWLYMcn3FVri50YjWbQjQ
 6LkxSsOSeMwYeojkRxdzE8gKnE13zGEVXMTFQhiCvDyiD5EEX23w==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.82.83]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1McZnl-1pemeX0hWX-00d2Ax; Sun, 25
 Jun 2023 08:25:48 +0200
Message-ID: <b57afc45-6bf8-3849-856f-2873e60fcf97@web.de>
Date: Sun, 25 Jun 2023 08:25:36 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
To: Jane Chu <jane.chu@oracle.com>, nvdimm@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, kernel-janitors@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Ira Weiny <ira.weiny@intel.com>, Matthew Wilcox <willy@infradead.org>,
 Vishal Verma <vishal.l.verma@intel.com>
References: <20230615181325.1327259-1-jane.chu@oracle.com>
Subject: Re: [PATCH v5 0/1] dax: enable dax fault handler to report
 VM_FAULT_HWPOISON
Content-Language: en-GB
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20230615181325.1327259-1-jane.chu@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:gAZovbXW2wo+VwTavOegvxCPCkcjNQCyGtt+RpISjS1VCfpCUXf
 E5eWP4AyESD/Y5vF6J/Xb7bJFuyUXVpgSycvlvGxeZL/8qB85sLogdEsdQbHmzkRl6Sjpjs
 VDxOhC4pMYoMh1VVfLXMSxsSwjof45lY4k16etbOSCakZJRKiMlmWjkwd2DoZ5y5mNTyuAi
 dpXliTlt7imb+cF769zYw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:uWt9BTZzBVg=;psS3Um618upnuFeX/309VUxR9zs
 aCIpU2H4EL6b2g8JBe/gc/v5jcm6ajKghAsst1C8vDD8EGSuFU12CcnTInwD+4WCNbu8cMcjB
 ivMQEQ/q285W4EvzyHuIPyPTh3nt0Xey1gufeojuEfYIUpFq7cSIwYzOfMOX6nPqnOObFpEK3
 edL5mMP4PVDq7UOEc9f4MuKgkjG1PNyzzDXYYBzKxBGi8CrId6w2ZDLp0Ftz1IyyHVrWz6QZO
 Thk85/mQRkfPpKivb0WZRTqANgH/31oR8Ws2f3fsCGAV3AMijiLBOe6Nu3cqRzsFkElHOv2Ul
 GKTRkSnnVf+183MHI7hOo+95FdeBW7thfwkS3qBx66oYASfi9AGpK/qjMFbsxaalBVti9m7/O
 TMF3j3M4TaV6Ht0plr+HFog5yXisiYbwl9H6o52libW92InQrGUIr8kTcvSqPWNP1sc5PV9Td
 xa8c689GKOLh/b4xvMMFGXaQWYPjcZkhN00T+1Sy0h3TZh/WA+sPCdFtRl1LN1VFxtpie8mxH
 AyeJyTUcgcEGmN5GGzhcN8P2p4KwpDjOYil5Haz4YgXwjFpM3jneVPIaCZPaoyc2hVyABp0YX
 vEOWedEWkejhJAI8yQoUj3fIX+eP93IqPQSJquiD90GmwCiz/dKt9wJX/FtK9YRlkS9ZORuNT
 1V9nmbN4YT8sb8AL6ebGhj/1eFeXRmfwuhHKPxoTOe2O1+2LF+nRfohk9P/sGTxwP1TJidBCr
 x9FtdaJ+7ROlOHNkV728ivLd9YtYTYYiTYNd9tZ7T2KIvjEtsJzhv2MeagnLHDIK6D3urmYjq
 6Ad7E6AJsHRT4htl+Qc3IY9vJit4o4cqp++DJA6LDrvh98RR0nYsbRt3mAmzZplFjYehCtzl2
 Q8EjdMKYVh0kJW5YV76tEaeSsI82hQNtGp5/KUDGbkirYC61BGan59UGaOANoDF7s2ADVGbIq
 fDnOuQ==

> Change from v4:
=E2=80=A6

I suggest to omit the cover letter for a single patch.

Will any patch series evolve for your proposed changes?

Regards,
Markus
