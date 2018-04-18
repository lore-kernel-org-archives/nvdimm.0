Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x236.google.com (mail-oi0-x236.google.com
 [IPv6:2607:f8b0:4003:c06::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D086B22690AAB
 for <linux-nvdimm@lists.01.org>; Wed, 18 Apr 2018 07:30:26 -0700 (PDT)
Received: by mail-oi0-x236.google.com with SMTP id 188-v6so1755403oih.8
 for <linux-nvdimm@lists.01.org>; Wed, 18 Apr 2018 07:30:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0DEDF3B159719A448A49EF0E7B11E3222764E0C7@g01jpexmbkw01>
References: <20180417063848.5585-1-qi.fuli@jp.fujitsu.com>
 <20180417063848.5585-2-qi.fuli@jp.fujitsu.com>
 <CAPcyv4g16niVJ+X73nSB9vHn3kNdc_X3ydZ1wy22AwVEp-1Rdw@mail.gmail.com>
 <0DEDF3B159719A448A49EF0E7B11E3222764DF5B@g01jpexmbkw01>
 <CAPcyv4hc5OYNSJT2PpsCH-QcjtBFkMoc-D3TKvAL5UyB9ZZYHQ@mail.gmail.com>
 <0DEDF3B159719A448A49EF0E7B11E3222764E0C7@g01jpexmbkw01>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 18 Apr 2018 07:30:25 -0700
Message-ID: <CAPcyv4iZUv-q1SVhqmtsNRgCBj=C3rZqjmMEGZjNbc1xVhvCaQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] ndctl, util: add OPT_STRING_LIST to parse_option
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
To: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 18, 2018 at 3:09 AM, Qi, Fuli <qi.fuli@jp.fujitsu.com> wrote:
>> >> As far as I can see we do not need to allocate a list or add this new
>> >> OPT_STRING_LIST argument type. Just teach the util_<object>_filter()
>> routines
>> >> that the 'ident' argument may be a space delimited list.  See the attached
>> patch:
>> >
>> > Thank you for your comment.
>> >
>> > The OPT_STRING_LIST is copied from git.
>> > Consider multiple arguments per option should be supported not only in
>> > monitor and list but also in other commands, as Vishal mentioned:
>> >   "ndctl disable-namespace namespace1.0 namespace2.0 ..."
>>
>> In this case there's no "-n" option so the list parsing is already
>> handled by standard shell argument parsing, i.e. the argv[] array
>> already has the list split.
>>
>> > If you think this feature is not needed in other commands, I will delete
>> > OPT_STRING_LIST and make a v2 patch.
>>
>> I can see OPT_STRING_LIST potentially being useful in other scenarios,
>> but for the util_<object>_filter functions it seems an awkward fit to
>> me. We end up doing the parsing twice. Once to parse the space
>> separated list and again to parse each entry against the object to be
>> filtered. In this case I think it is cleaner to handle it internally
>> to the utility functions.  It also makes the util functions more
>> generically useful as I can now use them in scenarios where the string
>> list is not coming from the command line.
>>
>> Ross noted that the attachment got swallowed by the list, so here it
>> is pasted, please forgive any whitespace damage:
>
> Thank you very much, I made a v2 patch by referring to your sample patch.
>
> Going back to the OPT_STRING_LIST, I think it is necessary for ndctl.
> Because the other options in monitor like --dimm-event, --bus-event
> also need to support multiple space-separated arguments, these options
> should be made as a string_list.

Ok, yes, lets bring in string_list for that case.

> One more question is that do you think it is necessary for ndctl to copy
> OPT_FILENAME in parse_option from git? The difference between OPT_FILENAME
> and OPT_STRING is that there is an additional fix_filename() in OPTION_FILENAME
> to process file's path. Considering that ndctl monitor also has file options like
> --logfile, --conf-file, I think we'd better to copy it.

Yes, let's copy git's lead for filename fixups.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
