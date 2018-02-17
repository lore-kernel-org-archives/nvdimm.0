Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x231.google.com (mail-oi0-x231.google.com
 [IPv6:2607:f8b0:4003:c06::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 058AF22161164
 for <linux-nvdimm@lists.01.org>; Fri, 16 Feb 2018 16:48:19 -0800 (PST)
Received: by mail-oi0-x231.google.com with SMTP id y4so3446493oix.2
 for <linux-nvdimm@lists.01.org>; Fri, 16 Feb 2018 16:54:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180213185839.258C.E1E9C6FF@jp.fujitsu.com>
References: <20180209080225.5137-3-qi.fuli@jp.fujitsu.com>
 <CAPcyv4i=XAsM2OuGgmqdrBJZVhAtPNJFGFdk=HiFAoUB6Re=Gw@mail.gmail.com>
 <20180213185839.258C.E1E9C6FF@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 16 Feb 2018 16:54:12 -0800
Message-ID: <CAPcyv4ig9MuGnaD4zxDCL7vfVLEHGfNsUw-Z5gtY9bbEmG9STQ@mail.gmail.com>
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
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Feb 13, 2018 at 1:58 AM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
> Hi,
>
>> On Fri, Feb 9, 2018 at 12:02 AM, QI Fuli <qi.fuli@jp.fujitsu.com> wrote:
>> > This patch is used to add $ndctl create-monitor command, by which users can
>> > create a new monitor. Users can select the DIMMS to be monitored by using
>> > [--dimm] [--bus] [--region] [--namespace] options. The notifications can
>> > be outputed to a special file or syslog by using [--output] option, the
>> > special file will be placed under /var/log/ndctl. A name is also required for
>> > a monitor,so users can destroy the monitor by the name. When a monitor is
>> > created successfully, a file with same name will be created under
>> > /var/ndctl/monitor.
>> > Example:
>> > #ndctl create-monitor --monitor m_nmem1 --dimm nmem1 --output m_nmem.log
>>
>> Hi Qi,
>>
>> This is getting closer to where I want to see this go, but still some
>> architecture details to incorporate. I mentioned on the cover letter
>> that systemd can handle starting, stopping, and show the status of the
>> monitor. The other detail to incorporate is that monitor events can
>> come DIMMs, but also namespaces, regions, and the bus.
>>
>> The event list I have collected to date is:
>>
>> dimm-spares-remaining
>> dimm-media-temperature
>> dimm-controller-temperature
>> dimm-health-state
>> dimm-unclean-shutdown
>> dimm-detected
>> namespace-media-error
>> namespace-detected
>> region-media-error
>> region-detected
>> bus-media-error
>> bus-address-range-scrub-complete
>> bus-detected
>>
>> ...and I think all of those should be separate options, probably
>> something like the following, but I'd Vishal to comment if this scheme
>> can be handled with the bash tab-completion implementation:
>>
>>    ndctl monitor --dimm-events=spares-remaining,media-temperature
>> --namespace-events=all --regions-events --bus=ACPI.NFIT
>>
>> ...where an empty --<object>-events option is equivalent to
>> --<object>-events=all. Also, similar to "ndctl list" specifying
>> specific buses, namespaces, etc causes the monitor to filter the
>> objects based on those properties.
>
> Hmmmm....
>
> Currently, I'm confusing what features/options are required for nvdimm daemon.
> For example, what is use-case of "--bus=ACPI.NFIT"?

Other platforms may support different bus types, there are also
proposals like this one for custom NVDIMM buses [1]. The other use
case is allowing the user to monitor for any media error on the bus,
or the completion of ARS.

> For normal administorator of a server, what he/she's interest is
> "need to replace nvdimm module or not", and "need to backup/restore
> on the nvdimm module or not".

I think that's only part of it. Data center operations want to know
more than just when it is time to replace a module, they want to
collect almost any data that the operating system can provide about
the platform.

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

The reason for supporting those other event sources in my mind is
having a unified interface for tracking topology, health/status, and
error events.

>
> In addition, could you tell me what administrator/program can do
> on the following events? What nvdimm daemon should do on each event?
>
>   - media-temperature
>   - controller-temperature
>   - address-range-scrub-complete
>   - unclean-shutdown

Media temperature and controller temperature alarms can signal to data
center operations that the server is getting too hot, and might need
remediation, perhaps a specific fan has failed and replacing that fan
becomes a high priority when these alarms start firing.

Address-range-scrub complete might be a signal that the server may get
a boost in throughput since the overhead of the background operation
is now complete. ARS may continue to run long after the server has
booted, so the end of that event may be important to server loading
decisions.

Unclean shutdown notification allows events that occurred at the last
shutdown to be recorded at the next boot. Otherwise an operator would
need to write a separate tool to go retrieve this information. Having
it all in one place reduces the number of tools / data-sources that
operations infrastructure needs to consider.

[1]: https://lists.01.org/pipermail/linux-nvdimm/2018-January/013926.html
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
