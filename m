Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm02.jp.fujitsu.com (mgwkm02.jp.fujitsu.com [202.219.69.169])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D170621E11D07
 for <linux-nvdimm@lists.01.org>; Mon, 28 Aug 2017 18:01:45 -0700 (PDT)
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
 by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 4F632AC006D
 for <linux-nvdimm@lists.01.org>; Tue, 29 Aug 2017 10:04:22 +0900 (JST)
Date: Tue, 29 Aug 2017 10:03:50 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: [PATCH] libnvdimm: clean up command definitions
In-Reply-To: <CAPcyv4hw+REtb2be0WpBRWG3QXajEUFdG9vOXkV+H-ar7mZRhA@mail.gmail.com>
References: <20170828205033.GA6859@anatevka.americas.hpqcorp.net>
 <CAPcyv4hw+REtb2be0WpBRWG3QXajEUFdG9vOXkV+H-ar7mZRhA@mail.gmail.com>
Message-Id: <20170829100344.C729.E1E9C6FF@jp.fujitsu.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

> On Mon, Aug 28, 2017 at 1:50 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> >
> > On Mon, Aug 28, 2017 at 08:45:32AM -0700, Dan Williams wrote:
> >> Remove the command payloads that do not have an associated libnvdimm
> >> ioctl. I.e. remove the payloads that would only ever be carried in the
> >> ND_CMD_CALL envelope. This prevents userspace from growing unnecessary
> >> dependencies on this kernel header when userspace already has everything
> >> it needs to craft and send these commands.
> >
> > Userspace needs to include linux/ndctl.h to make the call as
> > that is where nd_cmd_pkg is defined.
> >
> > So you want to have some structures defined in ndctl.h and other
> > defined in the to be created libndctl-nfit.h?  Plus a third header
> > file for the HPE non-root calls?
> 
> Yes. ndctl.h exports the ioctl command payloads, everything that goes
> inside of ND_CMD_CALL is defined by userspace headers. The
> libndctl-nfit.h header is proposed as a place to land vendor agnostic
> NFIT-defined payloads, and any vendor specific definitions would
> remain internal to libndctl as they are today.
> 
> > Will libndctl-nfit.h be generally available and installed?
> 
> Yes, that's the plan.
> 
> > Will it be clean so that other applications can use it to get these
> > definitions?  Or will it be loaded w/ a bunch of stuff only useful
> > to your ndctl command?
> 
> Yes, that's the plan. It's a bug if libndctl-nfit.h is not generically
> clean for issuing the NFIT root device commands via some ND_CMD_CALL
> helpers from the base libndctl library.
> 
> In other words libndctl-nfit.h defines the payload and libndctl
> defines some general helpers for issuing commands.

Maybe I don't understand your idea yet, let me confirm it.

Certainly, current acpi driver does not need these definitions.
But, I think nfit_test.ko will need them to emulate these features.

Do you intend that libndctl-nfit.h should be defined at "include/uapi/linux/"
directory?
Otherwise, it should be defined at "tools/testing/nvdimm/" or 
"tools/testing/nvdimm/test" ?

Thanks,
---
Yasunori Goto


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
