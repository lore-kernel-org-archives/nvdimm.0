Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x232.google.com (mail-ot0-x232.google.com
 [IPv6:2607:f8b0:4003:c0f::232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F224621F2E0F2
 for <linux-nvdimm@lists.01.org>; Wed, 18 Apr 2018 19:09:37 -0700 (PDT)
Received: by mail-ot0-x232.google.com with SMTP id m22-v6so4164589otf.8
 for <linux-nvdimm@lists.01.org>; Wed, 18 Apr 2018 19:09:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0DEDF3B159719A448A49EF0E7B11E3222764E251@g01jpexmbkw01>
References: <20180417063848.5585-1-qi.fuli@jp.fujitsu.com>
 <20180417063848.5585-2-qi.fuli@jp.fujitsu.com>
 <CAPcyv4g16niVJ+X73nSB9vHn3kNdc_X3ydZ1wy22AwVEp-1Rdw@mail.gmail.com>
 <0DEDF3B159719A448A49EF0E7B11E3222764DF5B@g01jpexmbkw01>
 <CAPcyv4hc5OYNSJT2PpsCH-QcjtBFkMoc-D3TKvAL5UyB9ZZYHQ@mail.gmail.com>
 <0DEDF3B159719A448A49EF0E7B11E3222764E0C7@g01jpexmbkw01>
 <CAPcyv4iZUv-q1SVhqmtsNRgCBj=C3rZqjmMEGZjNbc1xVhvCaQ@mail.gmail.com>
 <0DEDF3B159719A448A49EF0E7B11E3222764E251@g01jpexmbkw01>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 18 Apr 2018 19:09:36 -0700
Message-ID: <CAPcyv4j4mirvPkfjiM94P+X+tNpw5LuEUt-7brcOSk8tzd_vcQ@mail.gmail.com>
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

On Wed, Apr 18, 2018 at 7:06 PM, Qi, Fuli <qi.fuli@jp.fujitsu.com> wrote:
>> > Thank you very much, I made a v2 patch by referring to your sample patch.
>> >
>> > Going back to the OPT_STRING_LIST, I think it is necessary for ndctl.
>> > Because the other options in monitor like --dimm-event, --bus-event
>> > also need to support multiple space-separated arguments, these options
>> > should be made as a string_list.
>>
>> Ok, yes, lets bring in string_list for that case.
>>
>
> Could you merge the OPT_STRING_LIST first?

Oh, I was assuming when you said string_list that you would redo the
patch to bring in the struct string_list implementation from git, and
not use the strtok() approach. I'd like to not diverge from that
implementation.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
