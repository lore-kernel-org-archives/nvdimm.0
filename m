Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x242.google.com (mail-ot0-x242.google.com
 [IPv6:2607:f8b0:4003:c0f::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CC301209603E4
 for <linux-nvdimm@lists.01.org>; Tue, 15 May 2018 10:07:16 -0700 (PDT)
Received: by mail-ot0-x242.google.com with SMTP id t1-v6so1043187oth.8
 for <linux-nvdimm@lists.01.org>; Tue, 15 May 2018 10:07:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0DEDF3B159719A448A49EF0E7B11E3222766AB3C@g01jpexmbkw01>
References: <20180507050926.17243-1-qi.fuli@jp.fujitsu.com>
 <20180507050926.17243-3-qi.fuli@jp.fujitsu.com>
 <CAPcyv4jaqbaKwAAoXd3C_VGRQCcWUXCA545AGyPPXd6D1eEByA@mail.gmail.com>
 <0DEDF3B159719A448A49EF0E7B11E3222766AB3C@g01jpexmbkw01>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 15 May 2018 10:07:14 -0700
Message-ID: <CAPcyv4hCiPQX85Wd445g-vWzCRX_Z5-f4eOMVmxyTVhV+3oEjA@mail.gmail.com>
Subject: Re: [PATCH v6 2/4] ndctl, monitor: add ndctl monitor daemon
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

On Tue, May 15, 2018 at 1:32 AM, Qi, Fuli <qi.fuli@jp.fujitsu.com> wrote:
[..]
>> Actually, I don't see a need to have LOG_DESTINATION_FILE at all. Why not just
>> do:
>>
>>     ndctl monitor 2>file
>>
>> ...to redirect stderr to a file?
>
> In my understanding, this stderr redirection does not make sense when ndctl monitor
> runs as a daemon, eg:
>    # ndctl monitor --logfile stderr --daemon 2>file
> What do you think?

True, and now that I look dnsmasq allows the same with its
--log-facility option. Ok, let's keep this feature.

I appreciate the continued effort and patience.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
