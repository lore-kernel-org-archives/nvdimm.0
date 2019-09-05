From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [ndctl PATCH v2 2/2] libdaxctl: fix device reconfiguration with
 builtin drivers
Date: Wed, 4 Sep 2019 19:36:34 -0700
Message-ID: <CAPcyv4hMbPAf8yNMfz0ByRKPxZFT-14b-7zvZphStFnwgjVKeA@mail.gmail.com>
References: <20190905011314.18610-1-vishal.l.verma@intel.com>
 <20190905011314.18610-2-vishal.l.verma@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20190905011314.18610-2-vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Vishal Verma <vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Brice Goglin <Brice.Goglin-MZpvjPyXg2s@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Wed, Sep 4, 2019 at 6:13 PM Vishal Verma <vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>
> When the driver of a given reconfiguration mode is builtin, libdaxctl
> isn't able to build a module lookup list using kmod. However, it doesn't
> need to fail in this case, as it is acceptable for a driver to be
> builtin.
>
> Indeed, since even with a modalias lookup list, we still have to resolve
> the target driver based on the mode using the module name, so relying on
> the modalias lookup to keep us impervious to module name changes is
> already flawed.
>
> Simplify module loading greatly by removing the modalias lookups, and
> directly getting the module from a named lookup. This transparently
> fixes the problem when the driver may be builtin instead of being a
> module.
>
> Link: https://github.com/pmem/ndctl/issues/108
> Cc: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reported-by: Brice Goglin <Brice.Goglin-MZpvjPyXg2s@public.gmane.org>
> Reported-by: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Signed-off-by: Vishal Verma <vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>
> v2:
>  - Remove modalias lookup lists entirely, and perform a simple name
>    based lookup (Dan)
>  - Fix the module expectation in the daxctl-devices unit test.
>
>  daxctl/lib/libdaxctl-private.h |  1 -
>  daxctl/lib/libdaxctl.c         | 75 ++++++++--------------------------
>  test/daxctl-devices.sh         |  7 +++-
>  3 files changed, 23 insertions(+), 60 deletions(-)

Mmm, that's nice.

Reviewed-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
