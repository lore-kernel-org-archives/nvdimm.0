Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8740310F5
	for <nvdimm@lists.linux.dev>; Tue,  8 Aug 2023 07:35:49 +0000 (UTC)
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20230808073542epoutp02ab4fc0c91faf83e8038abbf725f58fec~5WDpLHxbh1818318183epoutp027
	for <nvdimm@lists.linux.dev>; Tue,  8 Aug 2023 07:35:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20230808073542epoutp02ab4fc0c91faf83e8038abbf725f58fec~5WDpLHxbh1818318183epoutp027
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1691480142;
	bh=tBq9IoyDxGSev3Ld/OSnOu1FQ+tHbuEp4Bg5BSa6JwQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=g9Di6h2djSdYVG07QoD93F6oXVLkeTXT9ORI9IlWbzhm/ruLn+3yQJ8Gh85XJqgmD
	 i3VGdDayhslxEhFOiN0F2/DMn9VewRJ8Qf5PVsyrCcuowlSrU6ox+z+8pFMtKyclqH
	 gpwOFK2IfIZrARM8/oVAlnLQrs/qyUhU2m1KqMKc=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTP id
	20230808073541epcas2p12939e82ebfdcdbb1b1f18c39d5388e01~5WDoglrQj2522325223epcas2p1b;
	Tue,  8 Aug 2023 07:35:41 +0000 (GMT)
Received: from epsmgec2p1-new.samsung.com (unknown [182.195.36.69]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4RKlND6rLbz4x9Q3; Tue,  8 Aug
	2023 07:35:40 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
	epsmgec2p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	D2.46.29526.C40F1D46; Tue,  8 Aug 2023 16:35:40 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
	20230808073540epcas2p16c3298cb407ada78de8ebbb8327576f9~5WDnTj3Ii2520525205epcas2p1D;
	Tue,  8 Aug 2023 07:35:40 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20230808073540epsmtrp27d89aafe56e0a62623cec44221f4582e~5WDnSxgIO2836828368epsmtrp2-;
	Tue,  8 Aug 2023 07:35:40 +0000 (GMT)
X-AuditID: b6c32a4d-637c170000047356-b4-64d1f04cdb9b
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	C5.CD.14748.C40F1D46; Tue,  8 Aug 2023 16:35:40 +0900 (KST)
Received: from jehoon-Precision-7920-Tower (unknown [10.229.83.133]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20230808073540epsmtip2310590a7815e753b4ddd923be3e38acb~5WDnCWQpw1474314743epsmtip2X;
	Tue,  8 Aug 2023 07:35:40 +0000 (GMT)
Date: Tue, 8 Aug 2023 16:38:42 +0900
From: Jehoon Park <jehoon.park@samsung.com>
To: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, Alison Schofield
	<alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, Ira
	Weiny <ira.weiny@intel.com>, Dan Williams <dan.j.williams@intel.com>, Dave
	Jiang <dave.jiang@intel.com>, Davidlohr Bueso <dave@stgolabs.net>, Kyungsan
	Kim <ks0204.kim@samsung.com>, Junhyeok Im <junhyeok.im@samsung.com>, Jehoon
	Park <jehoon.park@samsung.com>
Subject: Re: [ndctl PATCH v2 1/3] libcxl: Update a revision by CXL 3.0
 specification
Message-ID: <20230808073842.GA4397@jehoon-Precision-7920-Tower>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20230807140206.00006232@Huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0xTVxzHc3rby8VYuat1ntQ5m4uLj1Foa0svjjKzMWgGLt2YS2a2dXe9
	d4XQ19qyoS6hGB4N2wgzAaRkWEOcjo2AljnBguUlgnGga3AwmA9wdsNBKe5hEFzpxcX/Pr/v
	73nO7xwMEbSjIizP7GBsZspIoGu4Z3t3JEuyQ1dpqbNSSU5OjaBkbfUIIC+NFaPkt2PfAfLC
	nbtc0j/jjCGbjo+iZGP/UYTs92HksHuIS37z70MeOV51kbNnraak70+eptH3O0cT9NYBTWVb
	E9BU1xdpFs48q0X356fmMhTN2MSMWW+h88wGNZGVo3tZp0yWyiSyFFJFiM2UiVET6dlaSUae
	MTIiIf6YMhZEJC1ltxNJaak2S4GDEeda7A41wVhpo1VlTbRTJnuB2ZBoZhy7ZVKpXBkJfD8/
	1zfo5VgD6wq9rl8QJyhZWwFiMYgrYOU1J1IB1mAC3AfglaHrMawRBnBx4vKq528Ab/i+5zxO
	uXnhr1VHJ4D3D5/mssYDALsn6sFKFBffCqc87VFG8efhjR9a0RUW4nIY+Lo72gPBGxAYPH6N
	t+JYj78FG8+Fowl8/EV4quUIyvJTcLBumrvCsbgMlteORMfYgMdD/9kBzkohiDdjsKzBjbDz
	pcOlkHeV18M/BtpiWBbBhdlOlGULfDA4zmPZCsP3Q1yWd8HZsbtRHcFzYeujzghjET0e9o1z
	WXkddPUuxbAyH7rKBGzmc7BiIARY3gR7A/2rE2jgctft1TsNAlgc+hFUgS3uJ47mfqIbywnQ
	cz6MuiMtkEitk8sYiztgS0eSB/CagIix2k0GRi+3yiRm5pP/V663mM6A6BveufccmGlZSuwB
	HAz0AIghhJDfMD1MC/g0deAgY7PobAVGxt4DlJFlfYmINugtkU9gduhkihSpIjlZppIrpSpi
	I//X0q9oAW6gHEw+w1gZ2+M8DhYrcnK+8AdvbXzGQv+muN78ypGFiWN5rjbXrYS08sWXlsXS
	PRztewda99Gb42bp6o6ussl53omcmqfV7pJ3hO96NyXMK4OvY+BNuhbfHYjrz3zU1z2pv/25
	3xcvdinvJUzftJTWzZ06epquC3VXb/60s+PDrLTa7dneuPFWvmnxxMk5eQ2o/GB7LFOllBxU
	fTZX2tzWxacOK+bbf/Jd3pJ9Lz7tStWdxn+K/JceImH5z1sVgZzXXuh4NVOU/xFIVQeKhi5m
	FaYLG5bqM3I8Y9DDT9q339Gkm9RktKZoi5OxHkONzmceLZx645DQ6CGcgzNXrcTwtuXybbvQ
	AU7moc7R828TXHsuJduJ2OzUf0ygcaZMBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFLMWRmVeSWpSXmKPExsWy7bCSvK7Ph4spBl1nBSzuPr7AZjF96gVG
	ixM3G9ksVt9cw2ix/+lzFosDrxvYLVYtvMZmsfjoDGaLo3s4LM7POsVisfLHH1aLWxOOMTnw
	eLQcecvqsXjPSyaPF5tnMnr0bVnF6DF1dr3H501yAWxRXDYpqTmZZalF+nYJXBmXf+1hLJjC
	U7H03R7GBsa7nF2MnBwSAiYSD/Z/ZQaxhQR2M0rc+xgOEZeWuNd8hR3CFpa433KEtYuRC6jm
	O6PElfdrWUASLAIqEo8X7GQEsdkEtCXub9/ABmKLCBhJXFl2kB2kgVlgGbPEpuaZYBuEBcIk
	Fu/4BNbAK2AvsWL9JDaIqS8YJab86WWDSAhKnJz5BGwDs4CWxI1/L5m6GDmAbGmJ5f84QMKc
	AoYS7dMvMIHYogLKEge2HWeawCg4C0n3LCTdsxC6FzAyr2KUTC0ozk3PTTYsMMxLLdcrTswt
	Ls1L10vOz93ECI4eLY0djPfm/9M7xMjEwXiIUYKDWUmEd96T8ylCvCmJlVWpRfnxRaU5qcWH
	GKU5WJTEeQ1nzE4REkhPLEnNTk0tSC2CyTJxcEo1MJ1+vXcf6+EcrT2TWLTc/JcIX331q/FO
	hd3EH3emm7E8OKQQl91lFyS+9YS4+9tiicenfOY6Fqpdz1ui8uo+k0Ryt+XeyxszEnpDOhnU
	PXjPtrxMrXNeeuB51Owy8+/7yjXLfzX9qFfg3fnyl+EEHr+/v47+q0tS7HgeZ3xP8W5i7rUo
	mfVzJvPfKVsinBJkH8C3MzuHOWPz0q1rz+y5cuy/DPcHq+tLNTV178RZ+P26//ulnNpMD08O
	7qLeH5unV4n/iPlQddiz+NxB2cfsH/Y+vyez6Wt71q2g6f1zLL/tzmDKPXh6enN0RnL9i+Cf
	Pd+3hnyclnrt7s+GeRlCE3MFXrOYf6vgqbilmfdqirwSS3FGoqEWc1FxIgCq68wnDQMAAA==
X-CMS-MailID: 20230808073540epcas2p16c3298cb407ada78de8ebbb8327576f9
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----epwi_rqhNG8Msojpj3uLMMcmnOFPbGwp42J4v7mfPu1fUkEb=_7956b_"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230807063523epcas2p45f74891b764d920b2a9bd22ddf6b6998
References: <20230807063549.5942-1-jehoon.park@samsung.com>
	<CGME20230807063523epcas2p45f74891b764d920b2a9bd22ddf6b6998@epcas2p4.samsung.com>
	<20230807063549.5942-2-jehoon.park@samsung.com>
	<20230807140206.00006232@Huawei.com>

------epwi_rqhNG8Msojpj3uLMMcmnOFPbGwp42J4v7mfPu1fUkEb=_7956b_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Mon, Aug 07, 2023 at 02:02:06PM +0100, Jonathan Cameron wrote:
> On Mon,  7 Aug 2023 15:35:47 +0900
> Jehoon Park <jehoon.park@samsung.com> wrote:
> 
> > Update the predefined value for device temperature field when it is not
> > implemented. (CXL 3.0.8.2.9.8.3.1)
> > 
> > Signed-off-by: Jehoon Park <jehoon.park@samsung.com>
> Hi Jehoon,
> 
> Key here is not that it was in 3.0, but that it was changed in 2.0 Errata F38
> and as such software doesn't need to cope with the old (wrong) value.
> 
> Good to state that clearly in the patch description.  If it had been merely
> a change for 3.0 there would have needed to be an enable bit to change the
> default behavior (or something like that).
> 
> Otherwise LGTM
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> 
Hi Jonathan, thanks for the reviews.

I will correct the revision history in the next patch.

> > ---
> >  cxl/lib/private.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/cxl/lib/private.h b/cxl/lib/private.h
> > index a641727..a692fd5 100644
> > --- a/cxl/lib/private.h
> > +++ b/cxl/lib/private.h
> > @@ -360,7 +360,7 @@ struct cxl_cmd_set_partition {
> >  #define CXL_CMD_HEALTH_INFO_EXT_CORRECTED_PERSISTENT_WARNING		(1)
> >  
> >  #define CXL_CMD_HEALTH_INFO_LIFE_USED_NOT_IMPL				0xff
> > -#define CXL_CMD_HEALTH_INFO_TEMPERATURE_NOT_IMPL			0xffff
> > +#define CXL_CMD_HEALTH_INFO_TEMPERATURE_NOT_IMPL			0x7fff
> >  
> >  static inline int check_kmod(struct kmod_ctx *kmod_ctx)
> >  {
> 

------epwi_rqhNG8Msojpj3uLMMcmnOFPbGwp42J4v7mfPu1fUkEb=_7956b_
Content-Type: text/plain; charset="utf-8"


------epwi_rqhNG8Msojpj3uLMMcmnOFPbGwp42J4v7mfPu1fUkEb=_7956b_--
