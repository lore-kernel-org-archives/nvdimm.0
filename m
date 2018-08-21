Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym02.jp.fujitsu.com (mgwym02.jp.fujitsu.com [211.128.242.41])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F20AD210F6735
 for <linux-nvdimm@lists.01.org>; Mon, 20 Aug 2018 19:17:39 -0700 (PDT)
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local
 (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
 by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id D2C4DAC011A
 for <linux-nvdimm@lists.01.org>; Tue, 21 Aug 2018 11:17:32 +0900 (JST)
From: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Subject: RE: [ndctl PATCH] ndctl, test: add UUID_LIBS for list_smart_dimm
Date: Tue, 21 Aug 2018 02:17:30 +0000
Message-ID: <0DEDF3B159719A448A49EF0E7B11E3223DAB4F1E@g01jpexmbkw24>
References: <20180820202108.16912-1-vishal.l.verma@intel.com>
In-Reply-To: <20180820202108.16912-1-vishal.l.verma@intel.com>
Content-Language: en-US
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: 'Vishal Verma' <vishal.l.verma@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

> -----Original Message-----
> From: Vishal Verma [mailto:vishal.l.verma@intel.com]
> Sent: Tuesday, August 21, 2018 5:21 AM
> To: linux-nvdimm@lists.01.org
> Cc: Vishal Verma <vishal.l.verma@intel.com>; Qi, Fuli/斉 福利
> <qi.fuli@jp.fujitsu.com>
> Subject: [ndctl PATCH] ndctl, test: add UUID_LIBS for list_smart_dimm
> 
> Some environments automatically include the missing library dependency, and others
> need it to be explicitly included.
> 
> Link: https://github.com/pmem/ndctl/issues/66
> Cc: QI Fuli <qi.fuli@jp.fujitsu.com>
> Fixes: d1941474111a ("ndctl, test: add a new unit test for monitor")
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  test/Makefile.am | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/test/Makefile.am b/test/Makefile.am index c224eb7..50bb2e4 100644
> --- a/test/Makefile.am
> +++ b/test/Makefile.am
> @@ -162,4 +162,5 @@ list_smart_dimm_SOURCES = \  list_smart_dimm_LDADD = \
>  		$(LIBNDCTL_LIB) \
>  		$(JSON_LIBS) \
> +		$(UUID_LIBS) \
>  		../libutil.a

Looks good to me.
Reviewed-by: QI Fuli <qi.fuli@jp.fujitsu.com>

Thank you very much.
 Qi

> --
> 2.14.4
> 


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
