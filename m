Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22a.google.com (mail-oi0-x22a.google.com
 [IPv6:2607:f8b0:4003:c06::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D1E58222CF1D3
 for <linux-nvdimm@lists.01.org>; Wed, 10 Jan 2018 08:33:29 -0800 (PST)
Received: by mail-oi0-x22a.google.com with SMTP id u83so4776314oie.7
 for <linux-nvdimm@lists.01.org>; Wed, 10 Jan 2018 08:38:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAN=ZobQyy3taNhB_sXjeeUdWx0xP1aL3icr5_+ANFmBH+4Ge5A@mail.gmail.com>
References: <CAN=ZobSmQ97gRKFaho7DPvXVD18W4145JfTQ5Ncf80Tw17fkGA@mail.gmail.com>
 <20171020162227.GA8576@linux.intel.com>
 <CAN=ZobRsTqFtLiibVDU=yoNPSSgd7S=DaM=p2JTWcBm9x2PjsA@mail.gmail.com>
 <CAPcyv4ifUJUJFKksk0atmfeMiOJoQRPzYU9Z633i0Cj8pjpD6A@mail.gmail.com>
 <CAN=ZobTYOgWxPbLcH275EK4PkoniMk+1g1HehxoXLp1bqUN9Bg@mail.gmail.com>
 <CAA9_cmff4YFQnP+1csz2Z_=dKcQeW5jYFC2QLcN9V4j1FV+zyA@mail.gmail.com>
 <CAN=ZobSKm8isvTEALkd_-X7Hyjbv6tH-Yy0UGtOTkn2_fKoqhA@mail.gmail.com>
 <CAA9_cmes_Strpx6jNYDOnxZ0DUENFpWOpL-65jvpv3ztQwB74Q@mail.gmail.com>
 <CACTTzNa06a4ZM6tkYesqf-19WfcSuJovD-AWKC8-obVp_cTOPQ@mail.gmail.com>
 <CAN=ZobTrcu9LALChbB2HT1Fw_aAnDLGotU0Uo8uhewf5c3E+UA@mail.gmail.com>
 <CAPcyv4iyoWkG1MLtJ8cKN=yoav7Wstck5sJdeJhjxGeLPCRn6w@mail.gmail.com>
 <CAN=ZobRRj2ccifvwvkTPs_MwcbEK8ncYA_ydX8+Ar8gQpYu_oA@mail.gmail.com>
 <CAN=ZobT3V_cfLGKaLyfrhUthtW6xqE5EJ1=1u3o4RvdM4fOd5w@mail.gmail.com>
 <CAA9_cmcr+7DhH3mSPRvCtyVK6F31GGmvkq8nEi1sNzchmK70qw@mail.gmail.com>
 <CAN=ZobQyy3taNhB_sXjeeUdWx0xP1aL3icr5_+ANFmBH+4Ge5A@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 10 Jan 2018 08:38:40 -0800
Message-ID: <CAPcyv4hOqiq8LjHv7Qtt5J1SxJouiwvJVvAS9WgzWbcnoWEeQw@mail.gmail.com>
Subject: Re: Detecting NUMA per pmem
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
To: Oren Berman <oren@lightbitslabs.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jan 10, 2018 at 7:23 AM, Oren Berman <oren@lightbitslabs.com> wrote:
> Now to all of the forum
>
> Hi Dan
>
> Thanks we are going to try this.
>
> Can you explain why this can cause this issue - is the NVDIMM memory space
> also being randomized?
> Is it done during runtime?
>

Yes, kaslr randomizes the direct map. We have seen problems with it in
the past relative to setting up pmem mappings. We fixed one such bug
with this commit:

fc5f9d5f151c x86/mm: Fix boot crash caused by incorrect loop count
calculation in sync_global_pgds()

...but it appears we may have another bug in this area.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
