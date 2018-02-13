Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm04.jp.fujitsu.com (mgwkm04.jp.fujitsu.com [202.219.69.171])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B002021CF1CEF
 for <linux-nvdimm@lists.01.org>; Tue, 13 Feb 2018 02:06:46 -0800 (PST)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 340E4AC00F7
 for <linux-nvdimm@lists.01.org>; Tue, 13 Feb 2018 19:12:29 +0900 (JST)
Date: Tue, 13 Feb 2018 19:12:25 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: [RFC PATCH v3 2/5] ndctl: monitor: add ndctl create-monitor
 command
In-Reply-To: <20180213185839.258C.E1E9C6FF@jp.fujitsu.com>
References: <CAPcyv4i=XAsM2OuGgmqdrBJZVhAtPNJFGFdk=HiFAoUB6Re=Gw@mail.gmail.com>
 <20180213185839.258C.E1E9C6FF@jp.fujitsu.com>
Message-Id: <20180213191222.258F.E1E9C6FF@jp.fujitsu.com>
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
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

> Hi,
> 
> > On Fri, Feb 9, 2018 at 12:02 AM, QI Fuli <qi.fuli@jp.fujitsu.com> wrote:
> > > This patch is used to add $ndctl create-monitor command, by which users can
> > > create a new monitor. Users can select the DIMMS to be monitored by using
> > > [--dimm] [--bus] [--region] [--namespace] options. The notifications can
> > > be outputed to a special file or syslog by using [--output] option, the
> > > special file will be placed under /var/log/ndctl. A name is also required for
> > > a monitor,so users can destroy the monitor by the name. When a monitor is
> > > created successfully, a file with same name will be created under
> > > /var/ndctl/monitor.
> > > Example:
> > > #ndctl create-monitor --monitor m_nmem1 --dimm nmem1 --output m_nmem.log
> > 
> > Hi Qi,
> > 
> > This is getting closer to where I want to see this go, but still some
> > architecture details to incorporate. I mentioned on the cover letter
> > that systemd can handle starting, stopping, and show the status of the
> > monitor. The other detail to incorporate is that monitor events can
> > come DIMMs, but also namespaces, regions, and the bus.
> > 
> > The event list I have collected to date is:
> > 
> > dimm-spares-remaining
> > dimm-media-temperature
> > dimm-controller-temperature
> > dimm-health-state
> > dimm-unclean-shutdown
> > dimm-detected
> > namespace-media-error
> > namespace-detected
> > region-media-error
> > region-detected
> > bus-media-error
> > bus-address-range-scrub-complete
> > bus-detected
> > 
> > ...and I think all of those should be separate options, probably
> > something like the following, but I'd Vishal to comment if this scheme
> > can be handled with the bash tab-completion implementation:
> > 
> >    ndctl monitor --dimm-events=spares-remaining,media-temperature
> > --namespace-events=all --regions-events --bus=ACPI.NFIT
> > 
> > ...where an empty --<object>-events option is equivalent to
> > --<object>-events=all. Also, similar to "ndctl list" specifying
> > specific buses, namespaces, etc causes the monitor to filter the
> > objects based on those properties.
> 
> Hmmmm....
> 
> Currently, I'm confusing what features/options are required for nvdimm daemon.
> For example, what is use-case of "--bus=ACPI.NFIT"? 
> 
> For normal administorator of a server, what he/she's interest is 
> "need to replace nvdimm module or not", and "need to backup/restore
> on the nvdimm module or not". 
> 
> For normal programs, they just use device name or directory/filename of
> the filesystem on the nvdimm.
> 
> To backup thier data, he/she need to solve relationship between
> nvdimm modules and device name (/dev/pmem* or /dev/dax*).
> 
> So, IMHO, I suppose "namespace(device name) specifying (or all namespace)"
> is enough the following events which requires replace the nvdimm module.
> 
>  - spare-remaining
>  - helth-state
>  - media-error
> 
> And I'm not sure what is use-case of specifying region, bus, and dimm
> on these events.
> 
> 
> In addition, could you tell me what administrator/program can do
> on the following events? What nvdimm daemon should do on each event?
> 
>   - media-temperature
>   - controller-temperature
>   - address-range-scrub-complete
>   - unclean-shutdown
> 

I would like to ask one more thing.

What should nvdimm daemon do on detected events of bus/region/namespace/dimm ?
IIRC, udev handles such hotplug events. 
What is relationship/roles between nvdimm daemon and udev?

Bye,

> 
> Thanks,
> 
> > 
> > Since "ndctl list" already has this filtering implemented I'd like to
> > see it refactored and shared between the 2 implementations rather than
> > duplicated as is done in this patch. In other words rework cmd_list()
> > into a generic nvdimm object walking routine with callback functions
> > to 'list' or 'monitor' a given object that matches the filter.
> > 
> > Let me know if the above makes sense. I'm thinking the 'ndctl list'
> > refactoring might be something I need to handle.
> > _______________________________________________
> > Linux-nvdimm mailing list
> > Linux-nvdimm@lists.01.org
> > https://lists.01.org/mailman/listinfo/linux-nvdimm
> 



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
