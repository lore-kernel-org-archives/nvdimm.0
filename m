From: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: device dax fails with alignments other than 1GB
Date: Wed, 08 Mar 2017 16:17:15 -0500
Message-ID: <x49h933qxic.fsf@segfault.boston.devel.redhat.com>
References: <x49lgsfqzeb.fsf@segfault.boston.devel.redhat.com>
 <5e517d8e-ab1e-af9f-b2a6-e23f243b53d6@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <5e517d8e-ab1e-af9f-b2a6-e23f243b53d6-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> (Dave Jiang's
 message of "Wed, 8 Mar 2017 13:49:23 -0700")
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> writes:

> I'll take a look. I know I ran fio tests around the time I submitted the
> dev-dax ioengine and did not run into that. But you are saying it's
> failing even before the 1G support went in?

Correct.  I hardly think that part matters now, though--I just was
surprised that I couldn't find a kernel that actually worked.

Thanks for taking a look!

Cheers,
Jeff
