Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22b.google.com (mail-oi0-x22b.google.com
 [IPv6:2607:f8b0:4003:c06::22b])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9355B21AE30DB
 for <linux-nvdimm@lists.01.org>; Mon, 10 Sep 2018 07:26:57 -0700 (PDT)
Received: by mail-oi0-x22b.google.com with SMTP id t68-v6so40407011oie.12
 for <linux-nvdimm@lists.01.org>; Mon, 10 Sep 2018 07:26:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <bd07c88ae9626ea1a66fb100113296d9d4033988.camel@hpe.com>
References: <76e07643e9c36e4273588bd3e7f29d1393de4c3d.camel@hpe.com>
 <x49zhwpfr6n.fsf@segfault.boston.devel.redhat.com>
 <bd07c88ae9626ea1a66fb100113296d9d4033988.camel@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 10 Sep 2018 07:26:55 -0700
Message-ID: <CAPcyv4jr9353bgUjzKaVsu4ZqFkwkwEKMpETLSqeyJQgYcg_tQ@mail.gmail.com>
Subject: Re: open sets ext4_da_aops for DAX existing files
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
To: "Kani, Toshi" <toshi.kani@hpe.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Sep 10, 2018 at 7:21 AM, Kani, Toshi <toshi.kani@hpe.com> wrote:
> On Mon, 2018-09-10 at 08:54 -0400, Jeff Moyer wrote:
>> "Kani, Toshi" <toshi.kani@hpe.com> writes:
>>
>> > I noticed that both ext4_da_aops and ext4_dax_aops are used on DAX
>> > mounted ext4 files.  Looking at open() path:
>>
>> Eek.  How did you notice this?
>
> I tested sync path on DAX files to see if it flushes processor cache
> properly. Then I noticed that it sometimes does, but sometimes doesn't.
> Looking into function traces, I realized that ext4_dax_writepages() and
> ext4_writepages() are called depending on their file status.

Yikes, and nice find!
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
