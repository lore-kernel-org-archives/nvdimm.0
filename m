Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym03.jp.fujitsu.com (mgwym03.jp.fujitsu.com [211.128.242.42])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DDA8B22489CB5
 for <linux-nvdimm@lists.01.org>; Fri, 16 Mar 2018 00:27:52 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 438FBAC013E
 for <linux-nvdimm@lists.01.org>; Fri, 16 Mar 2018 16:34:13 +0900 (JST)
Date: Fri, 16 Mar 2018 16:33:12 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: [RFC PATCH v4] ndctl: monitor: add ndctl monitor daemon
In-Reply-To: <CAPcyv4jRxaVu6XXcRDatr8VHJAdR-nn7DVb9Z3oUs_MmK9sBAQ@mail.gmail.com>
References: <58684e81-ac3a-718e-a717-0a1b54766100@jp.fujitsu.com>
 <CAPcyv4jRxaVu6XXcRDatr8VHJAdR-nn7DVb9Z3oUs_MmK9sBAQ@mail.gmail.com>
Message-Id: <20180316163309.7296.E1E9C6FF@jp.fujitsu.com>
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

> >  b) About using systemctl command
> >     3) Should we need to limit the maximum number of running daemons to be one?
> >        If yes, I am thinking the option should support multiple values, then
> >        users can modify the default configuration by using [--conf-file] option.
> >        # ndctl monitor --dimm nmem1,nmem2 --conf-file

I talked about here with Qi-san, and probably I understand what he really 
wanted to ask here.

Currently, ndctl user can specify just "one" filter option, like --dimm nmem1,
but he/she can not specify 2 or more options like --dimm nmem1,nmem2,nmem3.

So, he would like to ask which we should select in the following.

  a) Change ndctl for users to be able to specify multiple filter option.
     This change affects not only daemon, but also ndctl list command.
     In addition, we need to decide how much filter can be specified.
  b) Keep current filter.
     To monitor plural area(dimm/region/namespace/bus), plural daemons
     are executed for each area which is specified one option.
     This does not require option change.

Though Qi-san wanted to select b) at this question,
it is just workaround, we should select a) I think...

Thanks,


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
