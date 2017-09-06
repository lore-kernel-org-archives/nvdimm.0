Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym02.jp.fujitsu.com (mgwym02.jp.fujitsu.com [211.128.242.41])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 873FC2095BB66
 for <linux-nvdimm@lists.01.org>; Tue,  5 Sep 2017 18:26:09 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 9F935AC010F
 for <linux-nvdimm@lists.01.org>; Wed,  6 Sep 2017 10:28:54 +0900 (JST)
Date: Wed, 06 Sep 2017 10:28:09 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: [ndctl PATCH 1/5] ndctl: Introduce libndctl-nfit.h
In-Reply-To: <CAPcyv4j9UAWwXei9f49G_g-gwRvUvV7xsej1QrMr-XHq5bOP0g@mail.gmail.com>
References: <CAPcyv4joECiCkd3+GJ8dWq-MfN=6dg3_+QQ5h6Qg-chgTjfsgQ@mail.gmail.com>
 <CAPcyv4j9UAWwXei9f49G_g-gwRvUvV7xsej1QrMr-XHq5bOP0g@mail.gmail.com>
Message-Id: <20170906102805.5B5C.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: NVDIMM-ML <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

> Actually, since there's some other fixups needed on this series, I'll let
> you resend this with the "attribute packed" statements added back in. I'll
> follow on later with kernel and ndctl patches to remove the ones that are
> not needed.

Hmm, since I may still misunderstand yet, let me confirm it.

In my next patch, "attribute packed" statements should be added 
to ALL of structures again.

(that is, the followings should have "attribute packed" again.
  - nd_cmd_translate_spa
  - nd_cmd_ars_err_inj
  - nd_cmd_ars_err_inj_clear
  - nd_cmd_ars_err_inj_stat
)

Is this correct?




_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
