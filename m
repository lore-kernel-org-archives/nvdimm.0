Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x231.google.com (mail-oi0-x231.google.com
 [IPv6:2607:f8b0:4003:c06::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 56ECC21E43B47
 for <linux-nvdimm@lists.01.org>; Sat, 23 Sep 2017 10:21:14 -0700 (PDT)
Received: by mail-oi0-x231.google.com with SMTP id v188so2258452oia.5
 for <linux-nvdimm@lists.01.org>; Sat, 23 Sep 2017 10:24:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0DEDF3B159719A448A49EF0E7B11E3222756C92E@g01jpexmbkw01>
References: <0DEDF3B159719A448A49EF0E7B11E3222756C92E@g01jpexmbkw01>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 23 Sep 2017 10:24:22 -0700
Message-ID: <CAPcyv4i7K7g553mivNgXpG-H+tEHFRgpPG7t1mZny_xec8KpsQ@mail.gmail.com>
Subject: Re: [RFC patch 4/4]ndctl: nvdimmd: notify/monitor the feathers of
 over threshold event
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 31, 2017 at 6:49 PM, Qi, Fuli <qi.fuli@jp.fujitsu.com> wrote:
> Notify.c is used to call the emulation of event of over threshold.
> You can test nvdimm daemon with the following command.
>
>  notify [nmemX] [all]

Let's make this an ndctl command... in fact this is a good candidate
of something to add to the "inject-error" command that Vishal is
developing.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
