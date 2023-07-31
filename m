Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDDFD62D
	for <nvdimm@lists.linux.dev>; Mon, 31 Jul 2023 03:29:11 +0000 (UTC)
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20230731032005epoutp019707b492840e61ce88341c0fc63375c1~21aLWm0au2461024610epoutp01c
	for <nvdimm@lists.linux.dev>; Mon, 31 Jul 2023 03:20:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20230731032005epoutp019707b492840e61ce88341c0fc63375c1~21aLWm0au2461024610epoutp01c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1690773605;
	bh=8bptU998lu3yxBAXjsg08onw4RTsSHqxvnTbQybWofc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=FG5I/doJfdlKrA4M7KCeo39f88jB/bEYEoX3aQ1Ghpt/FJAPhjYZ6iFjykRj/i074
	 r5KT2UUcXwze+d16KsLaFjr5IssnD2OSOjR+b2EAFXe4UJciy6kn5tyGAtrg7iQfgc
	 S224rMv7FvkTOraysT77kSW+yMoJW7NER0xtVFR0=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTP id
	20230731032004epcas2p2010cef021552af34648bdab99e0ce077~21aK0qqDq3202032020epcas2p2p;
	Mon, 31 Jul 2023 03:20:04 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.36.89]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4RDk502nzHz4x9Q3; Mon, 31 Jul
	2023 03:20:04 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
	epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
	C3.67.40133.46827C46; Mon, 31 Jul 2023 12:20:04 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
	20230731032003epcas2p220996143d692a12ec21c4a18f5e310a4~21aJyI29q2952629526epcas2p2M;
	Mon, 31 Jul 2023 03:20:03 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20230731032003epsmtrp29e921f78c80eace1a72d7102d3ef21f4~21aJxO9Ch2823628236epsmtrp2I;
	Mon, 31 Jul 2023 03:20:03 +0000 (GMT)
X-AuditID: b6c32a46-d17dea8000009cc5-c9-64c728648245
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	41.07.14748.36827C46; Mon, 31 Jul 2023 12:20:03 +0900 (KST)
Received: from jehoon-Precision-7920-Tower (unknown [10.229.83.133]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20230731032003epsmtip17fa56728a4672072871ded27ac2af54e~21aJl_IH73250232502epsmtip1i;
	Mon, 31 Jul 2023 03:20:03 +0000 (GMT)
Date: Mon, 31 Jul 2023 12:23:05 +0900
From: Jehoon Park <jehoon.park@samsung.com>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, "Jiang, Dave"
	<dave.jiang@intel.com>, "Schofield, Alison" <alison.schofield@intel.com>,
	"im, junhyeok" <junhyeok.im@samsung.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"bwidawsk@kernel.org" <bwidawsk@kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, "ks0204.kim@samsung.com" <ks0204.kim@samsung.com>
Subject: Re: [ndctl PATCH 2/2] cxl: add 'set-alert-config' command to cxl
 tool
Message-ID: <20230731032305.GB17128@jehoon-Precision-7920-Tower>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <6aae3a0c078eaed0324831111d0d95c0b2e42b14.camel@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMJsWRmVeSWpSXmKPExsWy7bCmqW6KxvEUgxcLBC3uPr7AZtE8eTGj
	xfSpFxgtTtxsZLPY//Q5i8XiozOYLY7u4bA4P+sUi8XKH39YLW5NOMbkwOWxeM9LJo9NqzrZ
	PF5snsno0bdlFaPH501yAaxR2TYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5
	ibmptkouPgG6bpk5QEcpKZQl5pQChQISi4uV9O1sivJLS1IVMvKLS2yVUgtScgrMC/SKE3OL
	S/PS9fJSS6wMDQyMTIEKE7Iz7h3pZCo45FNxY/p+pgbGT45djJwcEgImEs8vPWLuYuTiEBLY
	wSix6uZpRgjnE6PElKcf2SGcb4wSr3qvMcG03Lxxgw0isZdRYsOjTijnJ6PEl+dbWECqWARU
	Jc7tXM4IYrMJaEvc376BDcQWETCQ2D5rLdgOZoE1zBL7rpwEKxIWCJD4cOwP2ApeAQeJ1Qee
	s0DYghInZz4BszkF3CVOP1sANkhUQFniwLbjTCCDJAQWckjsOLaTHeI+F4kHK9+wQtjCEq+O
	b4GKS0l8freXDcLOl/h58hZUTYHEpy8fWCBsY4l3N5+DxZkFMiRmdn8CinMAxZUljtxigQjz
	SXQc/ssOEeaV6GgTguhUleg6/oERwpaWOHzlKDOE7SHR3jiNCRJA/xglbt7ewzqBUX4Wktdm
	IdkGYetJ3Jg6hQ3Clpdo3jqbeRbQOmagucv/cUCYmhLrd+kvYGRbxSiWWlCcm55abFRgBI/6
	5PzcTYzg1KvltoNxytsPeocYmTgYDzFKcDArifCeCjiUIsSbklhZlVqUH19UmpNafIjRFBhp
	E5mlRJPzgck/ryTe0MTSwMTMzNDcyNTAXEmc917r3BQhgfTEktTs1NSC1CKYPiYOTqkGpt67
	/w4/O2x9LWf/18TfkxXufMgRm1jxOfqpTcfDMnNmozVGSVqnfIzDl8w8tmGjQqT4tCv39odq
	zPsQxd/kPatCd5f8d8OLmRffmwf9+XzowUa/gJQDiuLCtTahikcr/yudWL/x9JfNR7pjxRM3
	r9/FP3Umu3xN+sRTIUfuPGo/5b8yhc3z8ZLORwz3lv9Wf5067/Hy/3fE/m5m/VXGkiD6Qkvu
	5aYutz3p8/W2zc/+c/73hkqdpwcDljzf6az/Vv2A/cV0PX9NLt8nvMFfP0W8vnlzkaPqCV+v
	k5uyD1/xjChZ69Yc+Oi2ieyUCzVPI9UdFqRZFfl3SMWUmmhr7Ch66l/4dRfr0Wf5u3p/vZ6r
	xFKckWioxVxUnAgAFKQRS0YEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42LZdlhJTjdZ43iKwc0l2hZ3H19gs2ievJjR
	YvrUC4wWJ242slnsf/qcxWLx0RnMFkf3cFicn3WKxWLljz+sFrcmHGNy4PJYvOclk8emVZ1s
	Hi82z2T06NuyitHj8ya5ANYoLpuU1JzMstQifbsEroz+lUtYC+57VkxdKtbAuNq+i5GTQ0LA
	ROLmjRtsILaQwG5GibVXhSDi0hL3mq+wQ9jCEvdbjrBC1HxnlNh+2RLEZhFQlTi3czkjiM0m
	oC1xf/sGsDkiAgYS22etBYpzcTALbGKW2HV0BRNIQljAT+LEoztgNq+Ag8TqA89ZQIqEBP4x
	Sqx4fgYqIShxcuYTFhCbWUBHYufWO0BTOYBsaYnl/zggwvISzVtnM4PYnALuEqefLQBbLCqg
	LHFg23GmCYxCs5BMmoVk0iyESbOQTFrAyLKKUTK1oDg3PTfZsMAwL7Vcrzgxt7g0L10vOT93
	EyM4mrQ0djDem/9P7xAjEwfjIUYJDmYlEd5TAYdShHhTEiurUovy44tKc1KLDzFKc7AoifMa
	zpidIiSQnliSmp2aWpBaBJNl4uCUamC6cj3u0gNZY7P205WmS3NeSWcWB0tuCMlflmKsv9ff
	PTVLzXGiw+qErScNZ5k8F3ONeGC8M1zhh3Px43MVug+7REOP7vvB4aksXHAkV8e4lf+x74/f
	cmFO+eGBwufFXBUl922ay3LHm/f3Dl+p44lSIo5PKpdJpAgfWzuHceHCReuV93MvWHn5Ss6a
	ukNy5VrvXipf+Drn88+XDw8msATxfS/dsfqa7P762fF7YjfwP94u+Y43yOmrzh9Z67aDm/UY
	vjksDbw/c2smQ+/uJvYJt/2C5XWKMyIrNadvfsx6s18g7uUcjfVzesV8Ixnkrx/4kb+n6nLE
	+XCfg16L+T7/fMxyUptxX9ZR5kKNx0xKLMUZiYZazEXFiQDhu+IUFQMAAA==
X-CMS-MailID: 20230731032003epcas2p220996143d692a12ec21c4a18f5e310a4
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----0fR5D8yIpNNl77tk4nXhNCfTmNnUnmvpDlxfu2XVSHf_RJiV=_1e26e_"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230711070820epcas2p4ec4884b434c9cb748d5ebda4dd385955
References: <20230711071019.7151-1-jehoon.park@samsung.com>
	<CGME20230711070820epcas2p4ec4884b434c9cb748d5ebda4dd385955@epcas2p4.samsung.com>
	<20230711071019.7151-3-jehoon.park@samsung.com>
	<6aae3a0c078eaed0324831111d0d95c0b2e42b14.camel@intel.com>

------0fR5D8yIpNNl77tk4nXhNCfTmNnUnmvpDlxfu2XVSHf_RJiV=_1e26e_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

On Mon, Jul 24, 2023 at 10:07:47PM +0000, Verma, Vishal L wrote:
> Hi Jehoon,
> 
> Thanks for adding this. A few minor comments below, otherwise these
> look good.
> 

Hi, Vishal.

Thank you for comments. I agree with all of them, especially the use of strcmp.
I missed the awkward case you mentioned.
I'll send v2 patch soon with applying those comments.

Jehoon

> On Tue, 2023-07-11 at 16:10 +0900, Jehoon Park wrote:
> > Add a new command: 'set-alert-config', which configures device's warning alert
> > 
> >  usage: cxl set-alert-config <mem0> [<mem1>..<memN>] [<options>]
> > 
> >     -v, --verbose         turn on debug
> >     -S, --serial          use serial numbers to id memdevs
> >     -L, --life-used-threshold <threshold>
> >                           threshold value for life used warning alert
> >         --life-used-alert <'on' or 'off'>
> >                           enable or disable life used warning alert
> >     -O, --over-temperature-threshold <threshold>
> >                           threshold value for device over temperature warning alert
> >         --over-temperature-alert <'on' or 'off'>
> >                           enable or disable device over temperature warning alert
> >     -U, --under-temperature-threshold <threshold>
> >                           threshold value for device under temperature warning alert
> >         --under-temperature-alert <'on' or 'off'>
> >                           enable or disable device under temperature warning alert
> >     -V, --volatile-mem-err-threshold <threshold>
> >                           threshold value for corrected volatile mem error warning alert
> >         --volatile-mem-err-alert <'on' or 'off'>
> >                           enable or disable corrected volatile mem error warning alert
> >     -P, --pmem-err-threshold <threshold>
> >                           threshold value for corrected pmem error warning alert
> >         --pmem-err-alert <'on' or 'off'>
> >                           enable or disable corrected pmem error warning alert
> 
> No need to include the full usage text in the commit message - this is
> available in the man page. Just mention and describe what functionality
> is being added.
> 
> > 
> > Signed-off-by: Jehoon Park <jehoon.park@samsung.com>
> > ---
> >  Documentation/cxl/cxl-set-alert-config.txt |  96 +++++++++
> >  Documentation/cxl/meson.build              |   1 +
> >  cxl/builtin.h                              |   1 +
> >  cxl/cxl.c                                  |   1 +
> >  cxl/memdev.c                               | 219 ++++++++++++++++++++-
> >  5 files changed, 317 insertions(+), 1 deletion(-)
> >  create mode 100644 Documentation/cxl/cxl-set-alert-config.txt
> > 
> > diff --git a/Documentation/cxl/cxl-set-alert-config.txt b/Documentation/cxl/cxl-set-alert-config.txt
> > new file mode 100644
> > index 0000000..a291c09
> > --- /dev/null
> > +++ b/Documentation/cxl/cxl-set-alert-config.txt
> > @@ -0,0 +1,96 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +
> > +cxl-set-alert-config(1)
> > +=======================
> > +
> > +NAME
> > +----
> > +cxl-set-alert-config - set the warning alert threshold on a CXL memdev
> > +
> > +SYNOPSIS
> > +--------
> > +[verse]
> > +'cxl set-alert-config <mem0> [<mem1>..<memN>] [<options>]'
> > +
> > +DESCRIPTION
> > +-----------
> > +CXL device raises an alert when its health status is changed. Critical alert
> > +shall automatically be configured by the device after a device reset.
> > +If supported, programmable warning thresholds also be initialized to vendor
> > +recommended defaults, then could be configured by the host.
> 
> s/host/user/ ?
> 
> > 
> <snip>
> >  
> > +static int validate_alert_threshold(enum cxl_setalert_event event,
> > +                                   int threshold)
> > +{
> > +       if (event == CXL_SETALERT_LIFE_USED) {
> > +               if (threshold < 0 || threshold > 100) {
> > +                       log_err(&ml, "Invalid life used threshold: %d\n",
> > +                               threshold);
> > +                       return -EINVAL;
> > +               }
> > +       } else if (event == CXL_SETALERT_OVER_TEMP ||
> > +                  event == CXL_SETALERT_UNDER_TEMP) {
> > +               if (threshold < SHRT_MIN || threshold > SHRT_MAX) {
> > +                       log_err(&ml,
> > +                               "Invalid device temperature threshold: %d\n",
> > +                               threshold);
> > +                       return -EINVAL;
> > +               }
> > +       } else {
> > +               if (threshold < 0 || threshold > USHRT_MAX) {
> > +                       log_err(&ml,
> > +                               "Invalid corrected mem error threshold: %d\n",
> > +                               threshold);
> > +                       return -EINVAL;
> > +               }
> > +       }
> > +       return 0;
> > +}
> > +
> > +#define alert_param_set_threshold(arg, alert_event)                           \
> > +{                                                                             \
> > +       if (!param.arg##_alert) {                                             \
> > +               if (param.arg##_threshold) {                                  \
> > +                       log_err(&ml, "Action not specified\n");               \
> > +                       return -EINVAL;                                       \
> > +               }                                                             \
> > +       } else if (strncmp(param.arg##_alert, "on", 2) == 0) {                \
> 
> I see that ndctl-inject-smart also does strncmp, but I'm wondering if
> we should be a little more strict and use strcmp instead.
> 
> The option parser won't give us strings that are not nul-terminated, so
> it should be safe, and it will avoid something awkward like
> "--some-alert=onward".
> 
> Ideally we probably want a helper similar to the kernel's kstrtobool(),
> which would handle all of {on,true,1,t} and different capitalization as
> well, but that can be a follow on patch.
> 
> > +               if (param.arg##_threshold) {                                  \
> > +                       char *endptr;                                         \
> > +                       alertctx.arg##_threshold =                            \
> > +                               strtol(param.arg##_threshold, &endptr, 10);   \
> > +                       if (endptr[0] != '\0') {                              \
> > +                               log_err(&ml, "Invalid threshold: %s\n",       \
> > +                                       param.arg##_threshold);               \
> > +                               return -EINVAL;                               \
> > +                       }                                                     \
> > +                       rc = validate_alert_threshold(                        \
> > +                               alert_event, alertctx.arg##_threshold);       \
> > +                       if (rc != 0)                                          \
> > +                               return rc;                                    \
> > +                       alertctx.valid_alert_actions |= 1 << alert_event;     \
> > +                       alertctx.enable_alert_actions |= 1 << alert_event;    \
> > +               } else {                                                      \
> > +                       log_err(&ml, "Threshold not specified\n");            \
> > +                       return -EINVAL;                                       \
> > +               }                                                             \
> > +       } else if (strncmp(param.arg##_alert, "off", 3) == 0) {               \
> > +               if (!param.arg##_threshold) {                                 \
> > +                       alertctx.valid_alert_actions |= 1 << alert_event;     \
> > +                       alertctx.enable_alert_actions &= ~(1 << alert_event); \
> > +               } else {                                                      \
> > +                       log_err(&ml, "Disable not require threshold\n");      \
> > +                       return -EINVAL;                                       \
> > +               }                                                             \
> > +       } else {                                                              \
> > +               log_err(&ml, "Invalid action: %s\n", param.arg##_alert);      \
> > +               return -EINVAL;                                               \
> > +       }                                                                     \
> > +}
> > +
> > 
> 
> <snip>
> 
> > +int cmd_set_alert_config(int argc, const char **argv, struct cxl_ctx *ctx)
> > +{
> > +       int count = memdev_action(
> > +               argc, argv, ctx, action_set_alert_config, set_alert_options,
> > +               "cxl set-alert-config <mem0> [<mem1>..<memN>] [<options>]");
> > +       log_info(&ml, "set alert configuration %d mem%s\n",
> 
> Maybe "set alert configuration for %d ..."
> 
> > +                count >= 0 ? count : 0, count > 1 ? "s" : "");
> > +
> > +       return count >= 0 ? 0 : EXIT_FAILURE;
> > +}
> 

------0fR5D8yIpNNl77tk4nXhNCfTmNnUnmvpDlxfu2XVSHf_RJiV=_1e26e_
Content-Type: text/plain; charset="utf-8"


------0fR5D8yIpNNl77tk4nXhNCfTmNnUnmvpDlxfu2XVSHf_RJiV=_1e26e_--
