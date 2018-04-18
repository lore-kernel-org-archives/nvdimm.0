Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm03.jp.fujitsu.com (mgwkm03.jp.fujitsu.com [202.219.69.170])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ABFB722683917
 for <linux-nvdimm@lists.01.org>; Wed, 18 Apr 2018 03:09:32 -0700 (PDT)
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local
 (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
 by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id F0494AC01FA
 for <linux-nvdimm@lists.01.org>; Wed, 18 Apr 2018 19:09:22 +0900 (JST)
From: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Subject: RE: [PATCH 1/2] ndctl, util: add OPT_STRING_LIST to parse_option
Date: Wed, 18 Apr 2018 10:09:20 +0000
Message-ID: <0DEDF3B159719A448A49EF0E7B11E3222764E0C7@g01jpexmbkw01>
References: <20180417063848.5585-1-qi.fuli@jp.fujitsu.com>
 <20180417063848.5585-2-qi.fuli@jp.fujitsu.com>
 <CAPcyv4g16niVJ+X73nSB9vHn3kNdc_X3ydZ1wy22AwVEp-1Rdw@mail.gmail.com>
 <0DEDF3B159719A448A49EF0E7B11E3222764DF5B@g01jpexmbkw01>
 <CAPcyv4hc5OYNSJT2PpsCH-QcjtBFkMoc-D3TKvAL5UyB9ZZYHQ@mail.gmail.com>
In-Reply-To: <CAPcyv4hc5OYNSJT2PpsCH-QcjtBFkMoc-D3TKvAL5UyB9ZZYHQ@mail.gmail.com>
Content-Language: ja-JP
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
To: 'Dan Williams' <dan.j.williams@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

> >> As far as I can see we do not need to allocate a list or add this new
> >> OPT_STRING_LIST argument type. Just teach the util_<object>_filter()
> routines
> >> that the 'ident' argument may be a space delimited list.  See the attached
> patch:
> >
> > Thank you for your comment.
> >
> > The OPT_STRING_LIST is copied from git.
> > Consider multiple arguments per option should be supported not only in
> > monitor and list but also in other commands, as Vishal mentioned:
> >   "ndctl disable-namespace namespace1.0 namespace2.0 ..."
> 
> In this case there's no "-n" option so the list parsing is already
> handled by standard shell argument parsing, i.e. the argv[] array
> already has the list split.
> 
> > If you think this feature is not needed in other commands, I will delete
> > OPT_STRING_LIST and make a v2 patch.
> 
> I can see OPT_STRING_LIST potentially being useful in other scenarios,
> but for the util_<object>_filter functions it seems an awkward fit to
> me. We end up doing the parsing twice. Once to parse the space
> separated list and again to parse each entry against the object to be
> filtered. In this case I think it is cleaner to handle it internally
> to the utility functions.  It also makes the util functions more
> generically useful as I can now use them in scenarios where the string
> list is not coming from the command line.
> 
> Ross noted that the attachment got swallowed by the list, so here it
> is pasted, please forgive any whitespace damage:

Thank you very much, I made a v2 patch by referring to your sample patch.

Going back to the OPT_STRING_LIST, I think it is necessary for ndctl.
Because the other options in monitor like --dimm-event, --bus-event 
also need to support multiple space-separated arguments, these options 
should be made as a string_list.

One more question is that do you think it is necessary for ndctl to copy 
OPT_FILENAME in parse_option from git? The difference between OPT_FILENAME 
and OPT_STRING is that there is an additional fix_filename() in OPTION_FILENAME 
to process file's path. Considering that ndctl monitor also has file options like 
--logfile, --conf-file, I think we'd better to copy it.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
