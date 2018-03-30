Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x236.google.com (mail-oi0-x236.google.com
 [IPv6:2607:f8b0:4003:c06::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 80F9E224A9ED9
 for <linux-nvdimm@lists.01.org>; Fri, 30 Mar 2018 09:34:39 -0700 (PDT)
Received: by mail-oi0-x236.google.com with SMTP id t16-v6so8195358oih.3
 for <linux-nvdimm@lists.01.org>; Fri, 30 Mar 2018 09:34:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0DEDF3B159719A448A49EF0E7B11E3222764B6A2@g01jpexmbkw01>
References: <20180313113308.2136-1-qi.fuli@jp.fujitsu.com>
 <CAPcyv4jPghKyQ6AuVJ-R=fiKcQufzHs-DExzcyHTbshF-2bq1Q@mail.gmail.com>
 <0DEDF3B159719A448A49EF0E7B11E3222764A26E@g01jpexmbkw01>
 <CAPcyv4jGnJ7geYUsQxjnSiHnRwCOWx8HOYVcx+Bom7AfRYLsyA@mail.gmail.com>
 <0DEDF3B159719A448A49EF0E7B11E3222764B6A2@g01jpexmbkw01>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 30 Mar 2018 09:34:37 -0700
Message-ID: <CAPcyv4gVxw8OCnm0PsbC0PrBxpUBupvkK=w4L4p=gWQRsk4ouQ@mail.gmail.com>
Subject: Re: [RFC PATCH v4] ndctl: monitor: add ndctl monitor daemon
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
To: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Mar 30, 2018 at 12:34 AM, Qi, Fuli <qi.fuli@jp.fujitsu.com> wrote:
>> >> > In this implemention, when a ndctl monitor starts with [--daemon]
>> >> > option, all the arguments will be saved into a temp file named as
>> >> > daemon-name and placed under /etc/sysconfig/ndctl/ directory. The
>> >> > temp file would be used as an EnvironmentFile by systemd, and it
>> >> > would be deleted automatically when the systemd service is stopped.
>> >>
>> >> The monitors started by hand should be kept separate from the
>> >> monitors started by systemd. The default monitor started by systemd
>> >> should get its configuration from /etc/ndctl.conf, and we should
>> >> otherwise have a --conf-file option to the monitor to override the
>> >> default configuration. Any other monitors started outside of the
>> >> systemd should remain independent.
>> >>
>> >
>> > I prefer to add an EnvironmentFile like /etc/sysconfig/ndctl/monitor
>> > to systemd rather than add a configuration file. According to [1],
>> > environment variable substitution is supported in systemd.service, so
>> > we can define the variables through
>> "EnvironmentFile=/etc/sysconfig/ndctl/monitor".
>> > In this fashion, we do not need to add any extra codes to parse the configuration
>> file.
>> >
>> > In this case, [--conf-file] option is not necessary either.
>> > According to [2], sytemd units can be instantiated from a template
>> > file, thus we only need to add a template unit file in advance.
>> > If user wants to run multiple monitors with different configurations,
>> > they can differentiate them by adding multiple EnvironmentFiles, like
>> /etc/sysconfig/ndctl/<monitor1...n>.
>> > Then the monitors can be started by command like "# systemctl start
>> > ndctl-monitor@<monitor1...n>.service".
>> >
>> > When the monitors started by hand, it will do not need any
>> > configuration files, because we can add options and parameters directly.
>> >
>> > [1]https://www.freedesktop.org/software/systemd/man/systemd.service.ht
>> > ml
>> > [2]https://www.freedesktop.org/software/systemd/man/systemd.unit.html
>>
>> This seems to needlessly tie ndctl to systemd, it should be able to operate without
>> requiring systemd. I expect it would be straightforward to copy the configuration file
>> implementation from git.
>
> Would you like to explain why it should be able to operate without requiring systemd?

systemd is not universally available in all distributions and it is
useful to have custom configuration files for manually started
daemons.

Another consideration is that a sub-set of monitoring activities can
be done without root privileges. It would be unforunate if a user
could not specify changes to the configuration because those files are
root-only and owned by systemd.

> The reason we want to add the configuration file is that when starting the monitors by systemd,
> options and arguments cannot be passed by systemd.
> When we start monitors by using "# ndctl monitor" command, we do not need any
> configuration files, because options and arguments can be added directly.
>
> Furthermore, if we choose configuration file implementation, we may encounter the following problem.
> If we start the monitor with command like "# ndctl monitor --dimm nmem1 --daemon --conf-file /etc/ndctl.conf",
> when the variable of dimm in configuration file is not the same as the argument of [--dimm] option,
> which argument should the filter_dimm() refer to?

The command line option should union with the configuration file for
filtering options. I.e. if the config file says to monitor nmem0 and
the command line says to monitor nmem1 then the tool should monitor
both. If there are other settings the might be in conflict then
command line should override the configuration file.

This matches the policy of most daemons that I have encountered in Linux.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
