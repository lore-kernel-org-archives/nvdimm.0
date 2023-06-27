Received: from mout.web.de (mout.web.de [212.227.15.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A57013060
	for <nvdimm@lists.linux.dev>; Tue, 27 Jun 2023 16:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
 s=s29768273; t=1687883653; x=1688488453; i=markus.elfring@web.de;
 bh=vZzg3hUB9c0/c2EDpMXq4jCgv8V42aD4x813zltGi9w=;
 h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
 b=G9UlO9yKVNJYe5KjCZk37NXdsSlyZrYpXszmFOM81Qe0YdhiTKIH2jauu3shJS4Y32QPX02
 IM0c8ChN7PYM+tye40KxKU3/PWuN3ZaAwwchQWhUnUiJYF2ez5Hp7w7D4Hz1lz3zSLj/QdGq8
 W4tBS+gUve2ScllTVAloqKO+MycKcA50JAQ9KqgRdoZQyRtxO1+1cZsz6/OhGB1VpUN8/IVmE
 F6ThNqa0ACflmy2d9BMhvhlE8bqCX9927jCBYWJCN/yF3zVqsS4XyDJ10jiuJLwhj/Wlb+kTv
 x6JIL5ukSsoIgY1Sw3TT6QhlcVG9AT/9FokhL6YRo8Zi65TJnn3Q==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.82.83]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1Md6tr-1peIWk2Kwt-00a5dx; Tue, 27
 Jun 2023 18:34:13 +0200
Message-ID: <ba6d2b6b-87b8-29c9-93a9-0026ee7ae7ca@web.de>
Date: Tue, 27 Jun 2023 18:34:12 +0200
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
Content-Language: en-GB
To: Matthew Wilcox <willy@infradead.org>, kernel-janitors@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev
Cc: LKML <linux-kernel@vger.kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Ira Weiny <ira.weiny@intel.com>, Vishal Verma <vishal.l.verma@intel.com>,
 Jane Chu <jane.chu@oracle.com>
References: <20230615181325.1327259-1-jane.chu@oracle.com>
 <b57afc45-6bf8-3849-856f-2873e60fcf97@web.de>
 <18ca0017-821b-595c-0d5a-25adb04196c1@oracle.com>
 <be3db57c-29d0-cfc9-f0cc-1765b672c57e@web.de>
 <ZJr+ngIH877t9seI@casper.infradead.org>
 <b46b90b5-cc1d-9311-892b-a0f8abe155d6@web.de>
 <ZJsNPKGH903AxDy3@casper.infradead.org>
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <ZJsNPKGH903AxDy3@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:nJzBICGWUAtKtg9IiLRQ4YxQvEpwWCQPnmbhnPW/o2FRMJJ1xie
 9i0GChGP1en9MY2B/9y19M2ZIupZYK83Xb1BpjZta7g4USZzYeNuJZbcAFXJV9YP0VzlZN2
 lDMvTWtw5W3XAMUs/IcdoEnlQrPdfNmsoB56uFarmociBNkIkgXRpVWyF6z6FDLMPt3OoIe
 CRgknx26gZmufzD5gR/NA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:XLGM6xeV7ZE=;a77Jk8TmogkkM5njE1V34UbDzeh
 BUN63UKTitiuQaLgV6Z/uMCArmlsu2GxZAeDcXG55OgoO4vWRA4iqttEtC3GwwswEIv6MF+J3
 Jng+r6tq36OrkWiihG6Uf00s6iDlQaMEM1+yfQmGs0lr7JMisCVt4mDqXyo8sqzmTH+cngn/5
 0dw5tL/waSvyOLlGiXwU9g6ZWOBFY4kVGsegF9JeL3vvBtFLDLhXBFhBycPRfOLa48YeIF4st
 i4IdELcKIeYSnPvjDV2xqPCFx1iwboLcu5hm9nearXtTDNPR0CqVjhFM2fyJAgwPhDt8KFem5
 mBmiVqkAu7OWNzdeQTDJOpykO7ZSFnBuCdPY0eMgRl8MCLMSA8+CE/NMdvdlhuXSznGpOAhir
 mM2wYsd1FIjFAO7Bfsn8pHKoj6UpChzUBnNY4S8XEgJ2sZQ/xbXuYtNaK61knX3fz2KIH8hHR
 Ga8Ttk/NCaZkhlD4pS+JWSEJZOnf5UTvgZ0Wh+57wDoT/64gJY79DCHPw5T4wwwkNr9BGPOHo
 eMQDcU3WvpEApJwuCyuKCptVdBhucPkgX7ZRmEyACaKIr24vp6GePW5caPcD5o6MWNotD/AF/
 QW7+PDKOgQr7TjgngXN0wQRaAucZq3+HIpDBYI9st9aEAcsY/N2x1ELnP8waaEvR7wtRac0/3
 JBXKPJn00Fhvd+uN/S6KUq/6bUkYYI2w2NvcudQQQg0gyCceLExuqX+wJoZ/MFb7jgYYW/HFl
 g3HBYxy81qH7QdnvUDFxn706ar/xLrBa9m026zSpsiOhwM5anAtQ5ptQsUPF1PWz+1G8pv0WA
 cOzmRAMl35tpuJpdN+wzqAxKohhT5QFzu8tZLMayQqVEAb+Vfo4bfN3JEl7POvtc0OYpuZx20
 yjKnIoncAsLE5cXNh7G/0IfZjPD7YA3nKCDErKL9kQIwc3YSgCYB0amFmFCgIn1z/mFnpHgeI
 /NSORQ==

>> Would you insist on the usage of cover letters also for single patches?
>
> I would neither insist on it, nor prohibit it.

It seems that you can tolerate an extra message here.


> It simply does not make enough difference.

Can it occasionally be a bit nicer to receive all relevant information wit=
hin a single patch
instead of a combination of two messages?

Regards,
Markus
