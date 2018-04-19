Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm01.jp.fujitsu.com (mgwkm01.jp.fujitsu.com [202.219.69.168])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8E788226847AE
 for <linux-nvdimm@lists.01.org>; Wed, 18 Apr 2018 19:06:24 -0700 (PDT)
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local
 (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
 by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 9B61EAC01D7
 for <linux-nvdimm@lists.01.org>; Thu, 19 Apr 2018 11:06:10 +0900 (JST)
From: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Subject: RE: [PATCH 1/2] ndctl, util: add OPT_STRING_LIST to parse_option
Date: Thu, 19 Apr 2018 02:06:08 +0000
Message-ID: <0DEDF3B159719A448A49EF0E7B11E3222764E251@g01jpexmbkw01>
References: <20180417063848.5585-1-qi.fuli@jp.fujitsu.com>
 <20180417063848.5585-2-qi.fuli@jp.fujitsu.com>
 <CAPcyv4g16niVJ+X73nSB9vHn3kNdc_X3ydZ1wy22AwVEp-1Rdw@mail.gmail.com>
 <0DEDF3B159719A448A49EF0E7B11E3222764DF5B@g01jpexmbkw01>
 <CAPcyv4hc5OYNSJT2PpsCH-QcjtBFkMoc-D3TKvAL5UyB9ZZYHQ@mail.gmail.com>
 <0DEDF3B159719A448A49EF0E7B11E3222764E0C7@g01jpexmbkw01>
 <CAPcyv4iZUv-q1SVhqmtsNRgCBj=C3rZqjmMEGZjNbc1xVhvCaQ@mail.gmail.com>
In-Reply-To: <CAPcyv4iZUv-q1SVhqmtsNRgCBj=C3rZqjmMEGZjNbc1xVhvCaQ@mail.gmail.com>
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

> > Thank you very much, I made a v2 patch by referring to your sample patch.
> >
> > Going back to the OPT_STRING_LIST, I think it is necessary for ndctl.
> > Because the other options in monitor like --dimm-event, --bus-event
> > also need to support multiple space-separated arguments, these options
> > should be made as a string_list.
> 
> Ok, yes, lets bring in string_list for that case.
> 

Could you merge the OPT_STRING_LIST first?

> > One more question is that do you think it is necessary for ndctl to
> > copy OPT_FILENAME in parse_option from git? The difference between
> > OPT_FILENAME and OPT_STRING is that there is an additional
> > fix_filename() in OPTION_FILENAME to process file's path. Considering
> > that ndctl monitor also has file options like --logfile, --conf-file, I think we'd better
> to copy it.
> 
> Yes, let's copy git's lead for filename fixups.
> 
OK, I will make a patch for adding the OPTION_FILENAME to parse_option.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
