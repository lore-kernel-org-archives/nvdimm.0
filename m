Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E327820EF
	for <nvdimm@lists.linux.dev>; Tue,  8 Aug 2023 07:38:42 +0000 (UTC)
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20230808073840epoutp02a7022028397285edf157bcbca42e233d~5WGPLW86Z2121421214epoutp02y
	for <nvdimm@lists.linux.dev>; Tue,  8 Aug 2023 07:38:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20230808073840epoutp02a7022028397285edf157bcbca42e233d~5WGPLW86Z2121421214epoutp02y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1691480320;
	bh=u8qOwOVO31Y0JFhN58/ZSPjlrog54j8BJNCBnThIl34=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=TgeZuHLfnMZ+bV67hNhIEcVIFPKsdyPwlqCKZmf6DFQiQFx+hd75UK76QS1EJcU/a
	 LI5Z1GxM01r2uhNjb9QKiUKyW9u1WhtQCQT0Tsrnu6HB/rz5ZwWw2vR+lCd5jvgOCv
	 v88Wq8ZvSS14cEZrz9R6u9Ic8/EAC6NsI0naRoNc=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTP id
	20230808073839epcas2p23e35f03a53edcca765c0d0451a35a7d4~5WGOhe7oF2205322053epcas2p2n;
	Tue,  8 Aug 2023 07:38:39 +0000 (GMT)
Received: from epsmgec2p1.samsung.com (unknown [182.195.36.88]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4RKlRg2qnPz4x9Q3; Tue,  8 Aug
	2023 07:38:39 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
	epsmgec2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
	F4.E7.49986.FF0F1D46; Tue,  8 Aug 2023 16:38:39 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
	20230808073838epcas2p1556845e1483f17cc8eaa1b1c1e3c1e2d~5WGNcV7fe3040530405epcas2p1G;
	Tue,  8 Aug 2023 07:38:38 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20230808073838epsmtrp2e9f77325b935e2fcdec11c9f24acd1d1~5WGNbicnZ3007130071epsmtrp2h;
	Tue,  8 Aug 2023 07:38:38 +0000 (GMT)
X-AuditID: b6c32a43-5f9ff7000000c342-b6-64d1f0ff0545
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	9F.EB.30535.EF0F1D46; Tue,  8 Aug 2023 16:38:38 +0900 (KST)
Received: from jehoon-Precision-7920-Tower (unknown [10.229.83.133]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20230808073838epsmtip299ba9d528c80717d9b000dc3f9e91f69~5WGNL7x1Q1666716667epsmtip2J;
	Tue,  8 Aug 2023 07:38:38 +0000 (GMT)
Date: Tue, 8 Aug 2023 16:41:41 +0900
From: Jehoon Park <jehoon.park@samsung.com>
To: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, Alison Schofield
	<alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, Ira
	Weiny <ira.weiny@intel.com>, Dan Williams <dan.j.williams@intel.com>, Dave
	Jiang <dave.jiang@intel.com>, Davidlohr Bueso <dave@stgolabs.net>, Kyungsan
	Kim <ks0204.kim@samsung.com>, Junhyeok Im <junhyeok.im@samsung.com>, Jehoon
	Park <jehoon.park@samsung.com>
Subject: Re: [ndctl PATCH v2 2/3] libcxl: Fix accessors for temperature
 field to support negative value
Message-ID: <20230808074141.GB4397@jehoon-Precision-7920-Tower>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20230807141435.00004eb0@Huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEJsWRmVeSWpSXmKPExsWy7bCmqe7/DxdTDI5PF7S4+/gCm8X0qRcY
	LU7cbGSzWH1zDaPF/qfPWSwOvG5gt1i18BqbxeKjM5gtju7hsDg/6xSLxcoff1gtbk04xuTA
	49Fy5C2rx+I9L5k8XmyeyejRt2UVo8fU2fUenzfJBbBFZdtkpCampBYppOYl56dk5qXbKnkH
	xzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAJ2opFCWmFMKFApILC5W0rezKcovLUlVyMgv
	LrFVSi1IySkwL9ArTswtLs1L18tLLbEyNDAwMgUqTMjOeNH7gbHghWrF4WWfWRoYZ8p1MXJy
	SAiYSLz7cYWti5GLQ0hgB6PEya+HWUESQgKfGCUubPOFSHxjlNh95hE7TEfX5C3sEIm9jBK3
	7u1hh+j4ySjxoSEFxGYRUJHY++YYWJxNQFvi/vYNbCC2iICRxJVlB8GamQXmMUu8WHgJbJ2w
	QKbEnJZZYEW8AvYSU+//Y4SwBSVOznzCAmJzChhKfG9rBqsXFVCWOLDtOBPERWs5JH5vYYSw
	XSQ29c5ghbCFJV4d3wJ1tZTE53d72SDsfImfJ29B1RRIfPrygQXCNpZ4d/M5WJxZIEPixt8j
	QPUcQHFliSO3WCDCfBIdh/+yQ4R5JTrahCA6VSW6jn+AukBa4vCVo8wQtofEgtu/mSBh9YJR
	4mLTPqYJjPKzkHw2C8k2CFtHYsHuT0A2B5AtLbH8HweEqSmxfpf+AkbWVYxiqQXFuempyUYF
	hvC4Ts7P3cQITrxazjsYr8z/p3eIkYmD8RCjBAezkgjvvCfnU4R4UxIrq1KL8uOLSnNSiw8x
	mgLjaSKzlGhyPjD155XEG5pYGpiYmRmaG5kamCuJ895rnZsiJJCeWJKanZpakFoE08fEwSnV
	wJTwzv38A5OM2UJyJex7FI/WLYt5E/NdctnbPxGaHAdYkzfetjF4LG5tb7vW+vjP4LlvDUP4
	mZs71vBL5rSe3tfVJ7H+oyXDjJ3/dzHWRiT7PBA1vZkfWy1xzeSkxJ7sl58CHERl7tScuuUt
	cs6RT0QzdGnLns1LyydWvD2zeYrmt7ZioZmMiofeTwn7EH5QpLdr8UPt9zozRWZq/Ly3qbLP
	sciyQNtl3t33ZSIBtkEem7Q7V5rxdSVxMX3Vm/wzKq5k876JFebGlpf99Bh0415F/7v3VmVe
	kYyslc4i88RvsZU6Uqotqjnu6r84pHb3L4lN0OFfvpTRry3mXOy8cqfZBRIzJ4vfcDHljtqp
	xFKckWioxVxUnAgA3dw0yUUEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFLMWRmVeSWpSXmKPExsWy7bCSvO6/DxdTDLbO0La4+/gCm8X0qRcY
	LU7cbGSzWH1zDaPF/qfPWSwOvG5gt1i18BqbxeKjM5gtju7hsDg/6xSLxcoff1gtbk04xuTA
	49Fy5C2rx+I9L5k8XmyeyejRt2UVo8fU2fUenzfJBbBFcdmkpOZklqUW6dslcGX07L7AVrBC
	ueLtna9MDYyfpLsYOTkkBEwkuiZvYe9i5OIQEtjNKPFuyX8miIS0xL3mK+wQtrDE/ZYjrCC2
	kMB3RomWJ5ogNouAisTeN8fAatgEtCXub9/ABmKLCBhJXFl2EGwos8AyZolNzTOZQRLCApkS
	p+a8BxvEK2AvMfX+P0aIzS8YJSbsuc8GkRCUODnzCQuIzSygJXHj30ugiziAbGmJ5f84QMKc
	AoYS39uaweaICihLHNh2nGkCo+AsJN2zkHTPQuhewMi8ilEytaA4Nz232LDAKC+1XK84Mbe4
	NC9dLzk/dxMjOHq0tHYw7ln1Qe8QIxMH4yFGCQ5mJRHeeU/OpwjxpiRWVqUW5ccXleakFh9i
	lOZgURLn/fa6N0VIID2xJDU7NbUgtQgmy8TBKdXAdCZ2iWhrgFjvKdM5ev9e3X5g1qZ4ewZz
	WOHDcospy3VLpt2ZfeWantXJf6XsS9O3dn09Y7HQUUOWp0XWY5tC5K1n9e3KE6TMOPVP3+s8
	1XagMTsjo9Byj36rgknfoXl72hsNWFY/e/HRbvOlbc+W1uyZuu935cz0jBO8vBcat07zXnVt
	yQSFqQdYawz8X+zLe5u7+nqzn/hUzjOzP1/ep/RtitPlo3xZDcse34/ZsLvFxbVjSfeGJ8t3
	Gm3Vccl98r7th1Oa4frNrGv23drX29Zevu6T+NwTvUtkjZtXPRbKn5XtVzFlrZWajUOhhtn1
	KNUJ35q+HVlvspcp0D94Yto2Rz+l4yl1d+byN1gFMimxFGckGmoxFxUnAgDDlutbDQMAAA==
X-CMS-MailID: 20230808073838epcas2p1556845e1483f17cc8eaa1b1c1e3c1e2d
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----0fR5D8yIpNNl77tk4nXhNCfTmNnUnmvpDlxfu2XVSHf_RJiV=_79807_"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230807063538epcas2p4965d5d117b8ef87ac4217bec53beff95
References: <20230807063549.5942-1-jehoon.park@samsung.com>
	<CGME20230807063538epcas2p4965d5d117b8ef87ac4217bec53beff95@epcas2p4.samsung.com>
	<20230807063549.5942-3-jehoon.park@samsung.com>
	<20230807141435.00004eb0@Huawei.com>

------0fR5D8yIpNNl77tk4nXhNCfTmNnUnmvpDlxfu2XVSHf_RJiV=_79807_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Mon, Aug 07, 2023 at 02:14:35PM +0100, Jonathan Cameron wrote:
> On Mon,  7 Aug 2023 15:35:48 +0900
> Jehoon Park <jehoon.park@samsung.com> wrote:
> 
> > Add a new macro function to retrieve a signed value such as a temperature.
> > Modify accessors for signed value to return INT_MAX when error occurs and
> > set errno to corresponding errno codes.
> 
> None of the callers have been modified to deal with INTMAX until next patch.
> So I think you need to combine the two to avoid temporary breakage.
> 
> Also you seem to be also changing the health status.  That seems
> to be unrelated to the negative temperature support so shouldn't
> really be in same patch.
>

Thank you for comments,

I will re-organize these patches in the next revision.

> > 
> > Signed-off-by: Jehoon Park <jehoon.park@samsung.com>
> > ---
> >  cxl/lib/libcxl.c | 32 +++++++++++++++++++++-----------
> >  1 file changed, 21 insertions(+), 11 deletions(-)
> > 
> > diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> > index af4ca44..fc64de1 100644
> > --- a/cxl/lib/libcxl.c
> > +++ b/cxl/lib/libcxl.c
> > @@ -3661,11 +3661,23 @@ cxl_cmd_alert_config_get_life_used_prog_warn_threshold(struct cxl_cmd *cmd)
> >  			 life_used_prog_warn_threshold);
> >  }
> >  
> > +#define cmd_get_field_s16(cmd, n, N, field)				\
> > +do {									\
> > +	struct cxl_cmd_##n *c =						\
> > +		(struct cxl_cmd_##n *)cmd->send_cmd->out.payload;	\
> > +	int rc = cxl_cmd_validate_status(cmd, CXL_MEM_COMMAND_ID_##N);	\
> > +	if (rc)	{							\
> > +		errno = -rc;						\
> > +		return INT_MAX;						\
> > +	}								\
> > +	return (int16_t)le16_to_cpu(c->field);				\
> > +} while(0)
> > +
> >  CXL_EXPORT int
> >  cxl_cmd_alert_config_get_dev_over_temperature_crit_alert_threshold(
> >  	struct cxl_cmd *cmd)
> >  {
> > -	cmd_get_field_u16(cmd, get_alert_config, GET_ALERT_CONFIG,
> > +	cmd_get_field_s16(cmd, get_alert_config, GET_ALERT_CONFIG,
> >  			  dev_over_temperature_crit_alert_threshold);
> >  }
> >  
> > @@ -3673,7 +3685,7 @@ CXL_EXPORT int
> >  cxl_cmd_alert_config_get_dev_under_temperature_crit_alert_threshold(
> >  	struct cxl_cmd *cmd)
> >  {
> > -	cmd_get_field_u16(cmd, get_alert_config, GET_ALERT_CONFIG,
> > +	cmd_get_field_s16(cmd, get_alert_config, GET_ALERT_CONFIG,
> >  			  dev_under_temperature_crit_alert_threshold);
> >  }
> >  
> > @@ -3681,7 +3693,7 @@ CXL_EXPORT int
> >  cxl_cmd_alert_config_get_dev_over_temperature_prog_warn_threshold(
> >  	struct cxl_cmd *cmd)
> >  {
> > -	cmd_get_field_u16(cmd, get_alert_config, GET_ALERT_CONFIG,
> > +	cmd_get_field_s16(cmd, get_alert_config, GET_ALERT_CONFIG,
> >  			  dev_over_temperature_prog_warn_threshold);
> >  }
> >  
> > @@ -3689,7 +3701,7 @@ CXL_EXPORT int
> >  cxl_cmd_alert_config_get_dev_under_temperature_prog_warn_threshold(
> >  	struct cxl_cmd *cmd)
> >  {
> > -	cmd_get_field_u16(cmd, get_alert_config, GET_ALERT_CONFIG,
> > +	cmd_get_field_s16(cmd, get_alert_config, GET_ALERT_CONFIG,
> >  			  dev_under_temperature_prog_warn_threshold);
> >  }
> >  
> > @@ -3905,8 +3917,6 @@ CXL_EXPORT int cxl_cmd_health_info_get_life_used(struct cxl_cmd *cmd)
> >  {
> >  	int rc = health_info_get_life_used_raw(cmd);
> >  
> > -	if (rc < 0)
> > -		return rc;
> 
> Why has this one changed?  It's a u8 so not as far as I can see affected by
> your new signed accessor.
> 
> 

I removed it because it was unnecessary code. (No action after error checking)
However, as you stated, this code cleaning is irrelevant to this patch.
I will revert this in the next patch.

> >  	if (rc == CXL_CMD_HEALTH_INFO_LIFE_USED_NOT_IMPL)
> >  		return -EOPNOTSUPP;
> >  	return rc;
> > @@ -3914,7 +3924,7 @@ CXL_EXPORT int cxl_cmd_health_info_get_life_used(struct cxl_cmd *cmd)
> >  
> >  static int health_info_get_temperature_raw(struct cxl_cmd *cmd)
> >  {
> > -	cmd_get_field_u16(cmd, get_health_info, GET_HEALTH_INFO,
> > +	cmd_get_field_s16(cmd, get_health_info, GET_HEALTH_INFO,
> >  				 temperature);
> >  }
> >  
> > @@ -3922,10 +3932,10 @@ CXL_EXPORT int cxl_cmd_health_info_get_temperature(struct cxl_cmd *cmd)
> >  {
> >  	int rc = health_info_get_temperature_raw(cmd);
> >  
> > -	if (rc < 0)
> > -		return rc;
> > -	if (rc == CXL_CMD_HEALTH_INFO_TEMPERATURE_NOT_IMPL)
> > -		return -EOPNOTSUPP;
> > +	if (rc == CXL_CMD_HEALTH_INFO_TEMPERATURE_NOT_IMPL) {
> > +		errno = EOPNOTSUPP;
> > +		return INT_MAX;
> > +	}
> >  	return rc;
> >  }
> >  
> 

------0fR5D8yIpNNl77tk4nXhNCfTmNnUnmvpDlxfu2XVSHf_RJiV=_79807_
Content-Type: text/plain; charset="utf-8"


------0fR5D8yIpNNl77tk4nXhNCfTmNnUnmvpDlxfu2XVSHf_RJiV=_79807_--
