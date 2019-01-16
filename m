Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5883921962301
 for <linux-nvdimm@lists.01.org>; Wed, 16 Jan 2019 09:47:55 -0800 (PST)
Subject: Re: [PATCH v8 02/12] ndctl: add passphrase update to ndctl
References: <154749627829.63704.2987015129166185725.stgit@djiang5-desk3.ch.intel.com>
 <154749640791.63704.5582105102507687245.stgit@djiang5-desk3.ch.intel.com>
 <CAPcyv4iJmw4vArep=XQfDR1qtdXMYjO=UDBhLWbLz3dWuqj82g@mail.gmail.com>
 <eeed9f9d34db7196244724a33a0124bb4968c4e0.camel@intel.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <e50fb1d3-dc11-de78-4aff-f7e0e16f446a@intel.com>
Date: Wed, 16 Jan 2019 10:47:54 -0700
MIME-Version: 1.0
In-Reply-To: <eeed9f9d34db7196244724a33a0124bb4968c4e0.camel@intel.com>
Content-Language: en-US
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
To: "Verma, Vishal L" <vishal.l.verma@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



On 1/16/19 10:43 AM, Verma, Vishal L wrote:
> 
> On Tue, 2019-01-15 at 17:56 -0800, Dan Williams wrote:
>> Some comments below...
>>
>> On Mon, Jan 14, 2019 at 12:06 PM Dave Jiang <dave.jiang@intel.com> wrote:
>>>
>>> Add API call for triggering sysfs knob to update the security for a DIMM
>>> in libndctl. Also add the ndctl "update-passphrase" to trigger the
>>> operation.
>>>
>>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>>> ---
>>>  Documentation/ndctl/Makefile.am                 |    4
>>>  Documentation/ndctl/ndctl-enable-passphrase.txt |   42 ++
>>>  Documentation/ndctl/ndctl-update-passphrase.txt |   38 ++
>>>  configure.ac                                    |   19 +
>>>  ndctl.spec.in                                   |    2
>>>  ndctl/Makefile.am                               |    3
>>>  ndctl/builtin.h                                 |    2
>>>  ndctl/dimm.c                                    |   94 +++++-
>>>  ndctl/lib/Makefile.am                           |    8
>>>  ndctl/lib/dimm.c                                |   39 ++
>>>  ndctl/lib/keys.c                                |  390 +++++++++++++++++++++++
>>>  ndctl/lib/libndctl.sym                          |    4
>>>  ndctl/libndctl.h                                |   35 ++
>>>  ndctl/ndctl.c                                   |    2
>>>  14 files changed, 669 insertions(+), 13 deletions(-)
>>>  create mode 100644 Documentation/ndctl/ndctl-enable-passphrase.txt
>>>  create mode 100644 Documentation/ndctl/ndctl-update-passphrase.txt
>>>  create mode 100644 ndctl/lib/keys.c
>>>
>>> diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
>>> index a30b139b..7ad6666b 100644
>>> --- a/Documentation/ndctl/Makefile.am
>>> +++ b/Documentation/ndctl/Makefile.am
>>> @@ -47,7 +47,9 @@ man1_MANS = \
>>>         ndctl-inject-smart.1 \
>>>         ndctl-update-firmware.1 \
>>>         ndctl-list.1 \
>>> -       ndctl-monitor.1
>>> +       ndctl-monitor.1 \
>>> +       ndctl-enable-passphrase.1 \
>>> +       ndctl-update-passphrase.1
>>>
>>>  CLEANFILES = $(man1_MANS)
>>>
>>> diff --git a/Documentation/ndctl/ndctl-enable-passphrase.txt b/Documentation/ndctl/ndctl-enable-passphrase.txt
>>> new file mode 100644
>>> index 00000000..c14a206c
>>> --- /dev/null
>>> +++ b/Documentation/ndctl/ndctl-enable-passphrase.txt
>>> @@ -0,0 +1,42 @@
>>> +// SPDX-License-Identifier: GPL-2.0
>>> +
>>> +ndctl-enable-passphrase(1)
>>> +==========================
>>> +
>>> +NAME
>>> +----
>>> +ndctl-enable-passphrase - enable the security passphrase for a NVDIMM
>>
>> *an NVDIMM
>>
>>> +
>>> +SYNOPSIS
>>> +--------
>>> +[verse]
>>> +'ndctl enable-passphrase' <dimm> [<options>]
>>
>> Is this true, there are no other required options besides the nmem
>> device? No support for more than one nmem at a time?
>>
>>> +
>>> +DESCRIPTION
>>> +-----------
>>> +Provide a command to enable the security passphrase for the NVDIMM.
>>
>> No need to say "Provide a command" that's assumed for a man page named
>> after a binary.
>>
>> So I'd say "Enable the security passphrase for one or more NVDIMMs.
>>
>>> +It is expected that the master key has already been loaded into the user
>>
>> Without listing the key-id as a required parameter it's not clear what
>> the usage should be.
>>
>>> +key ring. The encrypted key blobs will be created in /etc/nvdimm directory
>>
>> Is this stale, should be /etc/ndctl/keys, right? Given the directory
>> is changeable by the build system this source file should be built
>> with the key directory as a variable.
>>
>>> +with the file name of "nvdimm-<hostname>-<dimm unique id>.blob".
>>
>> That's quite a bit to type out? Is there a command to discover this
>> file name, or can we provide a short-hand?
> 
> I also noticed the actual file created was of the format:
> 
>   "nvdimm-<dimm unique id>-<hostname>.blob"
> 
> One of them should be made consistent with the other..

I'll fix the documentation. I changed the format for ease of parsing
sometimes during the development and missed the update to the
documentation here.

> 
>>
>>> +
>>> +The command will fail if the nvdimm key is already in the user key ring and/or
>>> +the key blob already resides in /etc/nvdimm.
>>
>> I feel like this is missing a create-passphrase step, and/or that
>> there needs to be an example in the man page. The man page should show
>> sohow to create the pre-requisite material, or reference another
>> command that will handle the details. I don't think the user interface
>> should ever expose "nvdimm-<hostname>-<dimm unique id>.blob" as
>> something the user needs to type... if at all possible. Maybe a global
>> "set-kek" command to write out the key-encryption-key to a
>> configuration file that enable-passphrase can consult by default
>> rather than require it to be passed to every enable-passphrase
>> invocation?
>>
>>> Do not touch the /etc/nvdimm
>>> +directory and let ndctl manage the keys, unless you know what you are doing.
>>
>> I think the "unless you know what you are doing." sentiment goes
>> without saying for a man page. If anything I'd ship a README file in
>> /etc/ndctl/keys if you're worried about manual edits to that
>> directory.
>>
>>> +
>>> +OPTIONS
>>> +-------
>>> +<dimm>::
>>> +include::xable-dimm-options.txt[]
>>> +
>>> +-m::
>>> +--master=::
>>> +       Key name for the master key used to seal the NVDIMM security keys.
>>> +       The format would be <key_type>:<master_key_name>
>>> +       i.e.: trusted:master-nvdimm
>>
>> "master" is ambiguous when we have master passphrases and master keys.
>> Let's call it the KEK (key-encryption-key) and reserve "master" for
>> "master passphrase".
>>
>>> +-p::
>>> +--key-path=::
>>> +       Path to where key related files resides. This parameter is optional
>>> +       and the default is set to /etc/ndctl/keys.
>>
>> Is this flexibility needed? Seems like something that can be omitted
>> unless/until a need arises.
>>
>>> +
>>> +include::../copyright.txt[]
>>> diff --git a/Documentation/ndctl/ndctl-update-passphrase.txt b/Documentation/ndctl/ndctl-update-passphrase.txt
>>> new file mode 100644
>>> index 00000000..dd6e4e4e
>>> --- /dev/null
>>> +++ b/Documentation/ndctl/ndctl-update-passphrase.txt
>>> @@ -0,0 +1,38 @@
>>> +// SPDX-License-Identifier: GPL-2.0
>>> +
>>> +ndctl-update-passphrase(1)
>>> +==========================
>>> +
>>> +NAME
>>> +----
>>> +ndctl-update-passphrase - update the security passphrase for a NVDIMM
>>
>> *an NVDIMM
>>
>>> +
>>> +SYNOPSIS
>>> +--------
>>> +[verse]
>>> +'ndctl update-passphrase' <dimm> [<options>]
>>
>> Same comment about required options.
>>
>>> +
>>> +DESCRIPTION
>>> +-----------
>>> +Provide a command to update the security key for NVDIMM.
>>
>> Same comment about "Provide a command"
>>
>>> +It is expected that the current and the new (if new master key is desired)
>>> +master key has already been loaded into the user key ring. The new encrypted
>>> +key blobs will be created in /etc/nvdimm directory
>>> +with the file name of "nvdimm-<hostname>-<dimm unique id>.blob".
>>> +
>>> +OPTIONS
>>> +-------
>>> +<dimm>::
>>> +include::xable-dimm-options.txt[]
>>> +
>>> +-m::
>>> +--master::
>>> +       New key name for the master key to seal the new nvdimm key, or the
>>> +       existing master key name. i.e trusted:master-key.
>>> +
>>> +-p::
>>> +--key-path=::
>>> +       Path to where key related files resides. This parameter is optional
>>> +       and the default is set to /etc/ndctl/keys.
>>
>> Same comment about an example and the need for key-path.
>>
>>> +
>>> +include::../copyright.txt[]
>>> diff --git a/configure.ac b/configure.ac
>>> index aa07ec7b..22efc871 100644
>>> --- a/configure.ac
>>> +++ b/configure.ac
>>> @@ -154,6 +154,7 @@ fi
>>>  AC_SUBST([systemd_unitdir])
>>>  AM_CONDITIONAL([ENABLE_SYSTEMD_UNITS], [test "x$with_systemd" = "xyes"])
>>>
>>> +
>>>  ndctl_monitorconfdir=${sysconfdir}/ndctl
>>>  ndctl_monitorconf=monitor.conf
>>>  AC_SUBST([ndctl_monitorconfdir])
>>> @@ -161,6 +162,24 @@ AC_SUBST([ndctl_monitorconf])
>>>  AC_DEFINE_UNQUOTED(NDCTL_CONF_FILE, ["$ndctl_monitorconfdir/$ndctl_monitorconf"],
>>>         [default ndctl monitor conf path])
>>>
>>> +AC_ARG_WITH([keyutils],
>>> +           AS_HELP_STRING([--with-keyutils],
>>> +                       [Enable keyutils functionality (security).  @<:@default=yes@:>@]), [], [with_keyutils=yes])
>>> +
>>> +if test "x$with_keyutils" = "xyes"; then
>>> +       AC_CHECK_HEADERS([keyutils.h],,[
>>> +               AC_MSG_ERROR([keyutils.h not found, consider installing
>>> +                             keyutils-libs-devel.])
>>> +               ])
>>> +fi
>>> +AS_IF([test "x$with_keyutils" = "xyes"],
>>> +       [AC_DEFINE([ENABLE_KEYUTILS], [1], [Enable keyutils support])])
>>> +AM_CONDITIONAL([ENABLE_KEYUTILS], [test "x$with_keyutils" = "xyes"])
>>> +ndctl_keysdir=${sysconfdir}/ndctl/keys
>>> +AC_SUBST([ndctl_keysdir])
>>> +AC_DEFINE_UNQUOTED(NDCTL_KEYS_DIR, ["$ndctl_keysdir"],
>>> +       [default ndctl keys path])
>>
>> My bad, apparently AC_DEFINE_UNQUOTED falls over if $ndctl_keysdir is
>> made up of components that need further expansion. Instead add
>> NDCTL_KEYS_DIR to the new autogenerated ndctl/config.h file. See this
>> pending patch where I killed off AC_DEFINE_UNQUOTED usage:
>> https://patchwork.kernel.org/patch/10763963/
>>
>>> +
>>>  my_CFLAGS="\
>>>  -Wall \
>>>  -Wchar-subscripts \
>>> diff --git a/ndctl.spec.in b/ndctl.spec.in
>>> index 26396d4a..66466db6 100644
>>> --- a/ndctl.spec.in
>>> +++ b/ndctl.spec.in
>>> @@ -21,6 +21,7 @@ BuildRequires:        pkgconfig(uuid)
>>>  BuildRequires: pkgconfig(json-c)
>>>  BuildRequires: pkgconfig(bash-completion)
>>>  BuildRequires: pkgconfig(systemd)
>>> +BuildRequires: keyutils-libs-devel
>>>
>>>  %description
>>>  Utility library for managing the "libnvdimm" subsystem.  The "libnvdimm"
>>> @@ -119,6 +120,7 @@ make check
>>>  %{bashcompdir}/
>>>  %{_sysconfdir}/ndctl/monitor.conf
>>>  %{_unitdir}/ndctl-monitor.service
>>> +%{_sysconfdir}/ndctl/keys/
>>>
>>>  %files -n daxctl
>>>  %defattr(-,root,root)
>>> diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
>>> index ff01e068..120941a4 100644
>>> --- a/ndctl/Makefile.am
>>> +++ b/ndctl/Makefile.am
>>> @@ -30,7 +30,8 @@ ndctl_LDADD =\
>>>         ../libutil.a \
>>>         $(UUID_LIBS) \
>>>         $(KMOD_LIBS) \
>>> -       $(JSON_LIBS)
>>> +       $(JSON_LIBS) \
>>> +       -lkeyutils
>>
>> This should be conditional on whether ndctl was built with keyutils support.
>>
>> ...reading ahead in the patch I don't think ndctl actually has a
>> direct dependency on keyutils, right? It's abstracted behind the
>> libndctl routines, so do we need this?
>>
>> [..]
>>> diff --git a/ndctl/lib/dimm.c b/ndctl/lib/dimm.c
>>> index e03135d9..b64c9568 100644
>>> --- a/ndctl/lib/dimm.c
>>> +++ b/ndctl/lib/dimm.c
>>> @@ -624,3 +624,42 @@ NDCTL_EXPORT int ndctl_dimm_get_security(struct ndctl_dimm *dimm,
>>>
>>>         return 0;
>>>  }
>>> +
>>> +NDCTL_EXPORT bool ndctl_dimm_security_supported(struct ndctl_dimm *dimm)
>>> +{
>>> +       enum nd_security_state state;
>>> +       int rc;
>>> +
>>> +       rc = ndctl_dimm_get_security(dimm, &state);
>>> +       if (rc < 0)
>>> +               return false;
>>> +
>>> +       if (state == ND_SECURITY_UNSUPPORTED)
>>> +               return false;
>>> +
>>> +       return true;
>>> +}
>>
>> I think the need for this goes away when ndctl_dimm_get_security()
>> returns the state directly.
>>
>> [..]
>>> diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
>>> index b01594e0..9d109b34 100644
>>> --- a/ndctl/ndctl.c
>>> +++ b/ndctl/ndctl.c
>>> @@ -88,6 +88,8 @@ static struct cmd_struct commands[] = {
>>>         { "inject-smart", { cmd_inject_smart } },
>>>         { "wait-scrub", { cmd_wait_scrub } },
>>>         { "start-scrub", { cmd_start_scrub } },
>>> +       { "enable-passphrase", { cmd_passphrase_setup } },
>>
>> Maybe call the command setup-passphrase. All the other enable commands
>> are just toggling dynamic state, this one is creating persistent
>> key-material.
>>
>>> +       { "update-passphrase", { cmd_passphrase_update } },
>>>         { "list", { cmd_list } },
>>>         { "monitor", { cmd_monitor } },
>>>         { "help", { cmd_help } },
>>>
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
