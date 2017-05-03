Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it0-x231.google.com (mail-it0-x231.google.com
 [IPv6:2607:f8b0:4001:c0b::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2475D21A1348F
 for <linux-nvdimm@lists.01.org>; Wed,  3 May 2017 08:38:15 -0700 (PDT)
Received: by mail-it0-x231.google.com with SMTP id e65so38357669ita.1
 for <linux-nvdimm@lists.01.org>; Wed, 03 May 2017 08:38:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOSf1CHLiO85NN1mo+4AmgDc2RvqNmiLEcp1cANX58Ojn0sSqA@mail.gmail.com>
References: <20170427091552.17694-1-oohall@gmail.com>
 <CAPcyv4id9q+6mKtqqJYzGdVN74Q5=-Rzirizs+U0RiJ-oF2Kyw@mail.gmail.com>
 <CAOSf1CEh379QGym155L6ALxU14xvF5pm6fyN=LDcKM_Q+wFGuA@mail.gmail.com>
 <CAPcyv4gLZiM_rBCOHiUdczTwbVB=QPa-eWVNVrG8tU82LKUjAw@mail.gmail.com>
 <CAOSf1CE2ugvN8WANYA5x-UhLiUA=sH1jTVEZUCR4wW8uGU_EMw@mail.gmail.com>
 <CAPcyv4g+mf4t=MjawD7hFf5hvs0H2DWMTjvPV3=zAShHpyQvTA@mail.gmail.com>
 <CAOSf1CHLiO85NN1mo+4AmgDc2RvqNmiLEcp1cANX58Ojn0sSqA@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 3 May 2017 08:38:13 -0700
Message-ID: <CAPcyv4jZEw_28ROTLiQkzg_cQMuO=m-sT89nVSsedecB1ah+-Q@mail.gmail.com>
Subject: Re: [PATCH] nvdimm: Export supported alignments via sysfs
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
To: Oliver O'Halloran <oohall@gmail.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 3, 2017 at 12:08 AM, Oliver O'Halloran <oohall@gmail.com> wrote:
> On Wed, May 3, 2017 at 2:17 PM, Dan Williams <dan.j.williams@intel.com> wrote:
[..]
>>> Fair enough.
>>
>> All that said, there's nothing stopping us from making 'align' it's
>> own mechanism. Where the first entry in the list is the current
>> setting, in contrast to btt that decorates the current sector-size
>> setting with square brackets.
>
> I'd be okay with this provided we force the alignment to one of the
> supported values. Currently the only validation done by the kernel is:
>
>         if (!is_power_of_2(val) || val < PAGE_SIZE || val > SZ_1G)
>                 return -EINVAL;

Yes, we'd need to validate the input against the supported values.
There are no known binaries in the wild that I  know of that depend on
this looser definition, so we should be ok to change it.

> So you can set an unsupported value by poking at sysfs directly. This
> behaviour is useful for testing since you can use it to force an
> alignment failure in the DAX fault handler.

I'd rather move that test support to something like the nfit_test
infrastructure.

> I'm not overly concerned
> if it goes, but it's something to keep in mind. I still think it would
> be cleaner if we just added a separate attribute.

I'm still having a hard time seeing how redundant sysfs attributes is "clean".
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
