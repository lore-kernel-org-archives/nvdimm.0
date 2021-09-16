Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8E03FC3
	for <nvdimm@lists.linux.dev>; Thu, 16 Sep 2021 22:12:52 +0000 (UTC)
Received: by mail-pl1-f170.google.com with SMTP id d18so4803604pll.11
        for <nvdimm@lists.linux.dev>; Thu, 16 Sep 2021 15:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5XlA8VV13MfPhro9gy26jzMbGkydoQynKRNbCKEdbhc=;
        b=hu+7fpttduQD2uX0BL9gsSpk8Ym/D+4/sIXreVYPrpTJtol0g7XvbrfHfvY4zbGnhY
         U7xTyREsC3/pV/TGGw3LJQLouqSAR0vhUqFdQxzV8IuCUwuVpa+TE0Z8iNntZ0G9UDHy
         R84NwAb1xtLNCqFaBWj6RJgx8rNFKUq4BG+lwaYhSZz3pyUYa/WtoPevyrZo6swBgRl3
         Dke3gycKGQJj4yt6PL58hts4/YaWmeZQsV7981JAVeiF3fx1C1V8g8u+i+tTS5ziebAe
         66ye4pupmnuBLO/czYUKu7tOS15UaXZDYu/E4JFRBKMehte6D6QJHGwrs0Ya6aWncWHd
         h6Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5XlA8VV13MfPhro9gy26jzMbGkydoQynKRNbCKEdbhc=;
        b=AxtxEyGpr9Cs/ntTCyRzh7n4k/uqop+W1DWFG255Wbys24Zqvia00P6Y19Sl31SsTs
         pQGX3DlfOXRNmrHVu2+8UkV8hh3GHoAEGG7rDy5t6jitMrcIFrxQaO6NDLZj6N47KKea
         G05TGMwRyaLNsrB2kn4H/X7PSguL3extdt01lQqKhHu2+TlXZRLUvHPXXAxpQq4dudb8
         dMIz/l+UgyH2w2EVFwu7NjIUIZTJt4k1Yy2LS6r9ivAs3vyh7T0Zn1zx3vALsRl3tLdW
         zLG1bEW0PYIQ103rXbtCZZe0xMQwpFsmZl9clO94SOtO/pL6QFKkYYgmNbvcIpcCMEcM
         1mNA==
X-Gm-Message-State: AOAM532nvLG6qI3dANNf1FmLArlkor9AO0ppBWYoSuHzbmf3KCwJ2AmP
	u8B4EUrd78I0GmlCXMbRydgXprUnsfujh+zObBpu4w==
X-Google-Smtp-Source: ABdhPJyzq/C34sTzxSleFHWDluZ7c97wGApxWqlTUIy00eOLZU9oT0NJJL21bfGeSOxi13zbUppPcra5EX42jKDi8fg=
X-Received: by 2002:a17:902:bd8d:b0:13a:8c8:a2b2 with SMTP id
 q13-20020a170902bd8d00b0013a08c8a2b2mr6647168pls.89.1631830371892; Thu, 16
 Sep 2021 15:12:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210831090459.2306727-1-vishal.l.verma@intel.com>
In-Reply-To: <20210831090459.2306727-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 16 Sep 2021 15:12:41 -0700
Message-ID: <CAPcyv4jGs9t6zKdzOJL1watQ7RvC0qdbT=jB2Cn948iM+0eLQw@mail.gmail.com>
Subject: Re: [ndctl PATCH 0/7] Policy based reconfiguration for daxctl
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, QI Fuli <qi.fuli@jp.fujitsu.com>, 
	"Hu, Fenghua" <fenghua.hu@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Aug 31, 2021 at 2:05 AM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> These patches add policy (config file) support to daxctl. The
> introductory user is daxctl-reconfigure-device. Sysadmins may wish to
> use daxctl devices as system-ram, but it may be cumbersome to automate
> the reconfiguration step for every device upon boot.
>
> Introduce a new option for daxctl-reconfigure-device, --check-config.
> This is at the heart of policy based reconfiguration, as it allows
> daxctl to look up reconfiguration parameters for a given device from the
> config system instead of the command line.
>
> Some systemd and udev glue then automates this for every new dax device
> that shows up, providing a way for the administrator to simply list all
> the 'system-ram' UUIDs in a config file, and not have to worry about
> anything else.
>
> An example config file can be:
>
>   # cat /etc/ndctl/daxctl.conf

Take these comments as provisional until I read through the rest, but
this is just a reaction to the proposed ini format.

>
>   [auto-online unique_identifier_foo]

I am thinking this section name should be "reconfigure-device
unique_identifier_foo" if only because resize might also be something
someone wants to do, and if other commands get config automation it
makes it clearer which config snippets apply to which command.

>   uuid = 48d8e42c-a2f0-4312-9e70-a837faafe862

I think this should be called:

"nvdimm.uuid"

...or something like that to make it clear this depends on dax devices
emitted by libnvdimm, and not those that come from "soft-reserved"
memory. It also helps distinguish if we ever get UUIDs in the HMAT
which is something I have been meaning to propose.

>   mode = system-ram

I can see this being "mode = devdax" if feature was being used to
change size or alignment.

>   online = true
>   movable = false

I wonder if these keys should be prefixed by the mode name:

system-ram.online = true
system-ram.movable = false

...so it's a bit more self documenting about which parameters are
sub-options, and delineates them from generic options like size.

> Any file under '/etc/ndctl/' can be used - all files with a '.conf' suffix
> will be considered when looking for matches.

any concern about name collisions between ndctl, daxctl, and cxl-cli
section names?
