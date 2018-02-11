Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x231.google.com (mail-oi0-x231.google.com
 [IPv6:2607:f8b0:4003:c06::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A9467203564DC
 for <linux-nvdimm@lists.01.org>; Sun, 11 Feb 2018 12:42:56 -0800 (PST)
Received: by mail-oi0-x231.google.com with SMTP id t78so9733370oih.4
 for <linux-nvdimm@lists.01.org>; Sun, 11 Feb 2018 12:48:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180209080225.5137-3-qi.fuli@jp.fujitsu.com>
References: <20180209080225.5137-1-qi.fuli@jp.fujitsu.com>
 <20180209080225.5137-3-qi.fuli@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 11 Feb 2018 12:48:43 -0800
Message-ID: <CAPcyv4i=XAsM2OuGgmqdrBJZVhAtPNJFGFdk=HiFAoUB6Re=Gw@mail.gmail.com>
Subject: Re: [RFC PATCH v3 2/5] ndctl: monitor: add ndctl create-monitor
 command
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
To: QI Fuli <qi.fuli@jp.fujitsu.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Feb 9, 2018 at 12:02 AM, QI Fuli <qi.fuli@jp.fujitsu.com> wrote:
> This patch is used to add $ndctl create-monitor command, by which users can
> create a new monitor. Users can select the DIMMS to be monitored by using
> [--dimm] [--bus] [--region] [--namespace] options. The notifications can
> be outputed to a special file or syslog by using [--output] option, the
> special file will be placed under /var/log/ndctl. A name is also required for
> a monitor,so users can destroy the monitor by the name. When a monitor is
> created successfully, a file with same name will be created under
> /var/ndctl/monitor.
> Example:
> #ndctl create-monitor --monitor m_nmem1 --dimm nmem1 --output m_nmem.log

Hi Qi,

This is getting closer to where I want to see this go, but still some
architecture details to incorporate. I mentioned on the cover letter
that systemd can handle starting, stopping, and show the status of the
monitor. The other detail to incorporate is that monitor events can
come DIMMs, but also namespaces, regions, and the bus.

The event list I have collected to date is:

dimm-spares-remaining
dimm-media-temperature
dimm-controller-temperature
dimm-health-state
dimm-unclean-shutdown
dimm-detected
namespace-media-error
namespace-detected
region-media-error
region-detected
bus-media-error
bus-address-range-scrub-complete
bus-detected

...and I think all of those should be separate options, probably
something like the following, but I'd Vishal to comment if this scheme
can be handled with the bash tab-completion implementation:

   ndctl monitor --dimm-events=spares-remaining,media-temperature
--namespace-events=all --regions-events --bus=ACPI.NFIT

...where an empty --<object>-events option is equivalent to
--<object>-events=all. Also, similar to "ndctl list" specifying
specific buses, namespaces, etc causes the monitor to filter the
objects based on those properties.

Since "ndctl list" already has this filtering implemented I'd like to
see it refactored and shared between the 2 implementations rather than
duplicated as is done in this patch. In other words rework cmd_list()
into a generic nvdimm object walking routine with callback functions
to 'list' or 'monitor' a given object that matches the filter.

Let me know if the above makes sense. I'm thinking the 'ndctl list'
refactoring might be something I need to handle.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
