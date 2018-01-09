Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x229.google.com (mail-oi0-x229.google.com
 [IPv6:2607:f8b0:4003:c06::229])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 94CE72208589C
 for <linux-nvdimm@lists.01.org>; Tue,  9 Jan 2018 15:00:39 -0800 (PST)
Received: by mail-oi0-x229.google.com with SMTP id n81so7872559oig.8
 for <linux-nvdimm@lists.01.org>; Tue, 09 Jan 2018 15:05:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAN=ZobTrcu9LALChbB2HT1Fw_aAnDLGotU0Uo8uhewf5c3E+UA@mail.gmail.com>
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
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 9 Jan 2018 15:05:49 -0800
Message-ID: <CAPcyv4iyoWkG1MLtJ8cKN=yoav7Wstck5sJdeJhjxGeLPCRn6w@mail.gmail.com>
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

On Tue, Jan 9, 2018 at 2:25 PM, Oren Berman <oren@lightbitslabs.com> wrote:
> Hi
>
> I would like to know if you encountered such a problem.
>
> We are accessing the nvram as memory from withing the kernel.
> By mapping dax device and reading its mapping we can know the physical
> address of the nvram.
> As a result we can access this address range in the kernel by calling
> phys_to_virt.
> This  is working in most case but we saw some issue that after reboot, when
> trying to read the info saved
> on the nvram before the power off, one kernel thread was able to read
> from this range but another kernel thread got page fault.
>
> This is not recreated very easily and we need run many reboot sequences to
> get this failure again.
> Are you aware of any mapping issues of nvram to kernel space?

When are you using phys_to_virt()? That will only return a valid
virtual address as long as the driver is loaded. It sounds like you
may be losing a race with the driver setting up or tearing down the
mappings.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
