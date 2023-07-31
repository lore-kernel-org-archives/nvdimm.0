Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F95762D
	for <nvdimm@lists.linux.dev>; Mon, 31 Jul 2023 03:20:44 +0000 (UTC)
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20230731031414epoutp0399417789884d2c2887d32ee0945d0d97~21VEWfKjl2493824938epoutp03U
	for <nvdimm@lists.linux.dev>; Mon, 31 Jul 2023 03:14:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20230731031414epoutp0399417789884d2c2887d32ee0945d0d97~21VEWfKjl2493824938epoutp03U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1690773254;
	bh=EvoVRW/Nwv0Mk71/ODo2TILsmOB0YaLo+kBS7XvAhD4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=CLoPwekrvBGMZ8DNQVzB8pFt9sGo3cmj519i1k4TVo2mc5h97lLNigJXEMP8ET/g5
	 H1Q1p7TUgBma0Ed6+UPAdIrPDJQa6ZcVySoEY459PSPBPYWpS5ZnUl3h7AJbJm65GS
	 QZ6leJ8vkyDWUMFWwfdcE1Rj2Yj6+qW49Dt0hxrs=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTP id
	20230731031413epcas2p23ec3171d16e8a0973bfe8a5b5dcd9946~21VDy0kkq0777407774epcas2p2X;
	Mon, 31 Jul 2023 03:14:13 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.36.68]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4RDjyF1gQlz4x9Q2; Mon, 31 Jul
	2023 03:14:13 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
	epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
	E7.C0.32393.50727C46; Mon, 31 Jul 2023 12:14:13 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
	20230731031412epcas2p4fb2631d72b455f205252e00b15119ef2~21VC3CVgB1185711857epcas2p4q;
	Mon, 31 Jul 2023 03:14:12 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20230731031412epsmtrp2553e33729e4c62270639b0a19ed88794~21VC2EjZ02510525105epsmtrp2J;
	Mon, 31 Jul 2023 03:14:12 +0000 (GMT)
X-AuditID: b6c32a48-adffa70000007e89-20-64c727056922
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	59.A6.14748.40727C46; Mon, 31 Jul 2023 12:14:12 +0900 (KST)
Received: from jehoon-Precision-7920-Tower (unknown [10.229.83.133]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20230731031412epsmtip11523e846057b23b76409a21db47c51eb~21VClbqOF3257032570epsmtip1v;
	Mon, 31 Jul 2023 03:14:12 +0000 (GMT)
Date: Mon, 31 Jul 2023 12:17:14 +0900
From: Jehoon Park <jehoon.park@samsung.com>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, "Jiang, Dave"
	<dave.jiang@intel.com>, "Schofield, Alison" <alison.schofield@intel.com>,
	"jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>, "im, junhyeok"
	<junhyeok.im@samsung.com>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"Weiny, Ira" <ira.weiny@intel.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, "dave@stgolabs.net" <dave@stgolabs.net>,
	"ks0204.kim@samsung.com" <ks0204.kim@samsung.com>
Subject: Re: [ndctl PATCH RESEND 2/2] libcxl: Fix accessors for temperature
 field to support negative value
Message-ID: <20230731031714.GA17128@jehoon-Precision-7920-Tower>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <ad6439d56a07c6fac2dc58a4b37fd852f79cfec8.camel@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNJsWRmVeSWpSXmKPExsWy7bCmhS6r+vEUg10tbBZ3H19gs5g+9QKj
	xYmbjWwWq2+uYbTY//Q5i8WqhdfYLBYfncFscXQPh8X5WadYLFb++MNqcWvCMSYHbo+WI29Z
	PRbvecnk8WLzTEaPvi2rGD2mzq73+LxJLoAtKtsmIzUxJbVIITUvOT8lMy/dVsk7ON453tTM
	wFDX0NLCXEkhLzE31VbJxSdA1y0zB+g6JYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUmpB
	Sk6BeYFecWJucWleul5eaomVoYGBkSlQYUJ2xqq/D9kKZhlUfPlzkqWBcbNmFyMHh4SAicSV
	vVZdjFwcQgI7GCV+N35nhnA+MUqsWHCTEcL5xigx++8XoAwnWMfmQ5vYIRJ7GSW2/HwGVfWT
	UWLOwwYmkCoWAVWJ+ydawTrYBLQl7m/fwAZiiwgYSGyftRasgVngObPE4u9/GEESwgK5Evv6
	lrOC2LwCDhJv5s1kgrAFJU7OfMICYnMKuEv03D0LZosKKEsc2HacCWSQhMAWDomTM+5C3eci
	8fH+TXYIW1ji1fEtULaUxOd3e9kg7HyJnydvsULYBRKfvnxggbCNJd7dfA4WZxbIkDjyuo8V
	EkrKEkdusUCE+SQ6Dv9lhwjzSnS0CUF0qkp0Hf/ACGFLSxy+chTqGg+JmVtmQcP0H6PEt9/n
	mScwys9C8tosJNsgbD2JG1OnsEHY8hLNW2czzwJaxww0d/k/DghTU2L9Lv0FjGyrGMVSC4pz
	01OLjQpM4DGfnJ+7iRGcirU8djDOfvtB7xAjEwfjIUYJDmYlEd5TAYdShHhTEiurUovy44tK
	c1KLDzGaAiNtIrOUaHI+MBvklcQbmlgamJiZGZobmRqYK4nz3mudmyIkkJ5YkpqdmlqQWgTT
	x8TBKdXA1NNW8Ln4t269b5bTtxMpcQ++H6rMPTB/z2G74DSlDTskbAKut8yYl/zn4lxWY/XN
	ZbH3jxfdl/HacsA9MZTZL8qnJWQrn0logVDMW4b1DjtCU7845rWdFSsy7/m9fdL6aL0pKlEX
	F1rtqq7ikVucfsnrh1LQpn5ti/3a7bLbO+ZKy2kJMYZIzF59ouf1hpW258vvsQa5px08Gc70
	Qtn3vKNjCMP/uQtOnhetfLJykuZSxX2v2/TctvYXu3sFfRNiSkjyqwi897Rnyr4/i/33bBXV
	lVwmwTe97fvmCUX3Dqo6v3urnfuwwLt1e2nGgyXbs4V9Z4ZwhaUUhSXpZskfrI1YvndV2B6B
	RaWMx9iUWIozEg21mIuKEwH0pvMGTgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42LZdlhJTpdF/XiKwbTjyhZ3H19gs5g+9QKj
	xYmbjWwWq2+uYbTY//Q5i8WqhdfYLBYfncFscXQPh8X5WadYLFb++MNqcWvCMSYHbo+WI29Z
	PRbvecnk8WLzTEaPvi2rGD2mzq73+LxJLoAtissmJTUnsyy1SN8ugSvjydX3zAXbdSu+NPQx
	NjC+Ueti5OSQEDCR2HxoE3sXIxeHkMBuRon5p7cyQSSkJe41X2GHsIUl7rccYYUo+s4oMbvr
	NjNIgkVAVeL+iVYwm01AW+L+9g1sILaIgIHE9llrGUEamAXeMkt8uHKcBSQhLJArsa9vOSuI
	zSvgIPFm3kwmiKn/GCWubFjDBpEQlDg58wlYA7OAjsTOrXeA4hxAtrTE8n8cEGF5ieats8EW
	cwq4S/TcPQtWLiqgLHFg23GmCYxCs5BMmoVk0iyESbOQTFrAyLKKUTK1oDg3PTfZsMAwL7Vc
	rzgxt7g0L10vOT93EyM4yrQ0djDem/9P7xAjEwfjIUYJDmYlEd5TAYdShHhTEiurUovy44tK
	c1KLDzFKc7AoifMazpidIiSQnliSmp2aWpBaBJNl4uCUamBqYetU0HxnsMzLnSVq8eHtG+en
	iCeHNzkpTFqVcE+Oa9aK3S/OM6czCbxNfZKS+OriafPKxuW7V/Ysvye8YJPV9jwbz41WOvfL
	OJlv7a/iT7AN5S1Jn73uy8XNOV+0i0xWCPz7WC7d847l8K4PDxrjz5z+xD2xu9Jevdre3vpN
	xbufAjO3Gh051Tdx49c5tndn5b45rb/k/sRUn695k3J/ta7Y9Pvf4wqJNV677h6I1ziyfk/t
	6xk+hxYJshdIdtbvuPfOLkBjZzCT/azdx9wKWjgsvNdUnv03s+SY9dLjkSy11jd2eYTJaU81
	zt/EYLXn0JzS1+oczGnbDvnlHbin88+nqzY/dPU5n9NnDSIZlFiKMxINtZiLihMBsOAZAiED
	AAA=
X-CMS-MailID: 20230731031412epcas2p4fb2631d72b455f205252e00b15119ef2
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----0fR5D8yIpNNl77tk4nXhNCfTmNnUnmvpDlxfu2XVSHf_RJiV=_1e11a_"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230717062633epcas2p44517748291e35d023f19cf00b4f85788
References: <20230717062908.8292-1-jehoon.park@samsung.com>
	<CGME20230717062633epcas2p44517748291e35d023f19cf00b4f85788@epcas2p4.samsung.com>
	<20230717062908.8292-3-jehoon.park@samsung.com>
	<ad6439d56a07c6fac2dc58a4b37fd852f79cfec8.camel@intel.com>

------0fR5D8yIpNNl77tk4nXhNCfTmNnUnmvpDlxfu2XVSHf_RJiV=_1e11a_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

On Mon, Jul 24, 2023 at 09:08:21PM +0000, Verma, Vishal L wrote:
> On Mon, 2023-07-17 at 15:29 +0900, Jehoon Park wrote:
> > Add a new macro function to retrieve a signed value such as a temperature.
> > Replace indistinguishable error numbers with debug message.
> > 
> > Signed-off-by: Jehoon Park <jehoon.park@samsung.com>
> > ---
> >  cxl/lib/libcxl.c | 36 ++++++++++++++++++++++++++----------
> >  1 file changed, 26 insertions(+), 10 deletions(-)
> > 
> > diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> > index 769cd8a..fca7faa 100644
> > --- a/cxl/lib/libcxl.c
> > +++ b/cxl/lib/libcxl.c
> > @@ -3452,11 +3452,21 @@ cxl_cmd_alert_config_get_life_used_prog_warn_threshold(struct cxl_cmd *cmd)
> >                          life_used_prog_warn_threshold);
> >  }
> >  
> > +#define cmd_get_field_s16(cmd, n, N, field)                            \
> > +do {                                                                   \
> > +       struct cxl_cmd_##n *c =                                         \
> > +               (struct cxl_cmd_##n *)cmd->send_cmd->out.payload;       \
> > +       int rc = cxl_cmd_validate_status(cmd, CXL_MEM_COMMAND_ID_##N);  \
> > +       if (rc)                                                         \
> > +               return 0xffff;                                          \
> > +       return (int16_t)le16_to_cpu(c->field);                                  \
> > +} while(0)
> > +
> >  CXL_EXPORT int
> >  cxl_cmd_alert_config_get_dev_over_temperature_crit_alert_threshold(
> >         struct cxl_cmd *cmd)
> >  {
> > -       cmd_get_field_u16(cmd, get_alert_config, GET_ALERT_CONFIG,
> > +       cmd_get_field_s16(cmd, get_alert_config, GET_ALERT_CONFIG,
> >                           dev_over_temperature_crit_alert_threshold);
> >  }
> >  
> > @@ -3464,7 +3474,7 @@ CXL_EXPORT int
> >  cxl_cmd_alert_config_get_dev_under_temperature_crit_alert_threshold(
> >         struct cxl_cmd *cmd)
> >  {
> > -       cmd_get_field_u16(cmd, get_alert_config, GET_ALERT_CONFIG,
> > +       cmd_get_field_s16(cmd, get_alert_config, GET_ALERT_CONFIG,
> >                           dev_under_temperature_crit_alert_threshold);
> >  }
> >  
> > @@ -3472,7 +3482,7 @@ CXL_EXPORT int
> >  cxl_cmd_alert_config_get_dev_over_temperature_prog_warn_threshold(
> >         struct cxl_cmd *cmd)
> >  {
> > -       cmd_get_field_u16(cmd, get_alert_config, GET_ALERT_CONFIG,
> > +       cmd_get_field_s16(cmd, get_alert_config, GET_ALERT_CONFIG,
> >                           dev_over_temperature_prog_warn_threshold);
> >  }
> >  
> > @@ -3480,7 +3490,7 @@ CXL_EXPORT int
> >  cxl_cmd_alert_config_get_dev_under_temperature_prog_warn_threshold(
> >         struct cxl_cmd *cmd)
> >  {
> > -       cmd_get_field_u16(cmd, get_alert_config, GET_ALERT_CONFIG,
> > +       cmd_get_field_s16(cmd, get_alert_config, GET_ALERT_CONFIG,
> >                           dev_under_temperature_prog_warn_threshold);
> >  }
> >  
> > @@ -3695,28 +3705,34 @@ static int health_info_get_life_used_raw(struct cxl_cmd *cmd)
> >  CXL_EXPORT int cxl_cmd_health_info_get_life_used(struct cxl_cmd *cmd)
> >  {
> >         int rc = health_info_get_life_used_raw(cmd);
> > +       struct cxl_ctx *ctx = cxl_memdev_get_ctx(cmd->memdev);
> >  
> >         if (rc < 0)
> > -               return rc;
> > +               dbg(ctx, "%s: Invalid command status\n",
> > +                   cxl_memdev_get_devname(cmd->memdev));
> >         if (rc == CXL_CMD_HEALTH_INFO_LIFE_USED_NOT_IMPL)
> > -               return -EOPNOTSUPP;
> > +               dbg(ctx, "%s: Life Used not implemented\n",
> > +                   cxl_memdev_get_devname(cmd->memdev));
> >         return rc;
> >  }
> >  
> >  static int health_info_get_temperature_raw(struct cxl_cmd *cmd)
> >  {
> > -       cmd_get_field_u16(cmd, get_health_info, GET_HEALTH_INFO,
> > +       cmd_get_field_s16(cmd, get_health_info, GET_HEALTH_INFO,
> >                                  temperature);
> >  }
> >  
> >  CXL_EXPORT int cxl_cmd_health_info_get_temperature(struct cxl_cmd *cmd)
> >  {
> >         int rc = health_info_get_temperature_raw(cmd);
> > +       struct cxl_ctx *ctx = cxl_memdev_get_ctx(cmd->memdev);
> >  
> > -       if (rc < 0)
> > -               return rc;
> > +       if (rc == 0xffff)
> > +               dbg(ctx, "%s: Invalid command status\n",
> > +                   cxl_memdev_get_devname(cmd->memdev));
> >         if (rc == CXL_CMD_HEALTH_INFO_TEMPERATURE_NOT_IMPL)
> > -               return -EOPNOTSUPP;
> > +               dbg(ctx, "%s: Device Temperature not implemented\n",
> > +                   cxl_memdev_get_devname(cmd->memdev));
> 
> Hi Jehoon,
> 
> libcxl tends to just return errno codes for simple accessors liek this,
> and leave it up to the caller to print additional information about why
> the call might have failed. Even though these are dbg() messages, I'd
> prefer leaving them out of this patch, and if there is a call site
> where this fails and there isn't an adequate error message printed as
> to why, then add these prints there.
> 
> Rest of the conversion to s16 looks good.
> 

Hi, Vishal.

Thank you for comment. I agree with the behavior of libcxl accessors as you
explained. FYI, the reason I replaced errno codes with dbg messages is that
those accessors are retreiving signed values. I thought returning errno codes
is not distinguishable from retrieved values when they are negative.
However, it looks like an overkill because a memory device works below-zero
temperature would not make sense in real world.

I'll send revised patch soon after reverting to errno codes and fixing
related codes in cxl/json.c.

Jehoon

> >         return rc;
> >  }
> >  
> 

------0fR5D8yIpNNl77tk4nXhNCfTmNnUnmvpDlxfu2XVSHf_RJiV=_1e11a_
Content-Type: text/plain; charset="utf-8"


------0fR5D8yIpNNl77tk4nXhNCfTmNnUnmvpDlxfu2XVSHf_RJiV=_1e11a_--
